;;;; pattern_matcher.lisp
;;;; Pattern matching engine — maps processed text to intents via keyword groups.

(in-package :cl-user)

(load (merge-pathnames "knowledge_base.lisp" *load-pathname*))

(defun pad-for-phrase-match (text)
  "Pad with spaces so whole-word / whole-phrase matching works."
  (concatenate 'string " " (string-downcase (or text "")) " "))

(defun whole-phrase-match-p (normalized-text pattern)
  "Match PATTERN as a whole phrase, not as a prefix of a longer word.
\"about you\" matches \"tell me about you\" but not \"about your contact\"."
  (when (and normalized-text pattern (plusp (length pattern)))
    (let* ((haystack (pad-for-phrase-match normalized-text))
           (needle (pad-for-phrase-match pattern)))
      (search needle haystack :test #'char-equal))))

(defun word-count (text)
  (length (remove "" (tokenize-string (string-trim '(#\space) text))
                  :test #'string=)))

(defun score-pattern-match (normalized-text pattern)
  "Score how well PATTERN matches NORMALIZED-TEXT.
Longer phrase matches receive higher scores.
Short filler words score weakly inside longer sentences."
  (if (whole-phrase-match-p normalized-text pattern)
      (let* ((base (* (length pattern) 10))
             (msg-words (max 1 (word-count normalized-text)))
             (pat-words (max 1 (word-count pattern))))
        ;; "okay" / "please" / "hi" must not beat real questions in long messages.
        (if (and (<= (length pattern) 7) (> msg-words (+ pat-words 2)))
            (floor base 5)
            base))
      0))

(defun score-intent (normalized-text intent)
  "Compute total match score for INTENT against NORMALIZED-TEXT."
  (let ((patterns (get-patterns-for-intent intent)))
    (reduce #'+ (mapcar (lambda (p) (score-pattern-match normalized-text p))
                        patterns)
            :initial-value 0)))

(defun filler-intent-p (intent)
  (member intent '(AFFIRMATIVE GREETING THANK_YOU)))

(defun find-best-intent (normalized-text)
  "Return the intent with the highest pattern match score.
Returns UNKNOWN if no pattern matches.
Contact-related queries prefer CONTACT_INFO over COMPANY_INFO."
  (let* ((scores (loop for intent in (get-all-intents)
                       for score = (score-intent normalized-text intent)
                       when (> score 0)
                       collect (cons intent score)))
         (sorted (sort (copy-list scores) #'> :key #'cdr))
         (best (car sorted))
         (runner-up (cadr sorted)))
    (cond
      ((null scores) 'UNKNOWN)
      ;; Prefer contact when the user clearly asks for email/phone/person
      ((and (assoc 'CONTACT_INFO scores)
            (or (whole-phrase-match-p normalized-text "email")
                (whole-phrase-match-p normalized-text "phone")
                (whole-phrase-match-p normalized-text "whatsapp")
                (whole-phrase-match-p normalized-text "contact person")
                (whole-phrase-match-p normalized-text "contact details")
                (whole-phrase-match-p normalized-text "contact support")
                (whole-phrase-match-p normalized-text "contacts")
                (whole-phrase-match-p normalized-text "company email")
                (whole-phrase-match-p normalized-text "your email")))
       'CONTACT_INFO)
      ;; Prefer a substantive intent over short filler matches.
      ((and best
            (filler-intent-p (car best))
            runner-up
            (not (filler-intent-p (car runner-up))))
       (car runner-up))
      ((and best
            (eq (car best) 'AFFIRMATIVE)
            (> (word-count normalized-text) 3))
       (if runner-up (car runner-up) 'UNKNOWN))
      (t (car best)))))

(defun match-intent (processed-input)
  "Accept NLP-processed input and return the matched intent symbol."
  (find-best-intent (getf processed-input :normalized)))

(defun describe-pattern-match (normalized-text intent)
  "Return matched patterns for demonstration traces."
  (let ((patterns (get-patterns-for-intent intent)))
    (loop for pattern in patterns
          when (whole-phrase-match-p normalized-text pattern)
          collect pattern)))
