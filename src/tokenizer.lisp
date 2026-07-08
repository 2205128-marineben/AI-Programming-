;;;; tokenizer.lisp
;;;; Tokenization and text normalization for the M-Float NLP pipeline.

(in-package :cl-user)

(defparameter *stopwords*
  '("the" "a" "an" "is" "are" "was" "were" "be" "been" "being" "am"
    "i" "me" "we" "our" "you" "your" "he" "she" "it" "they" "them"
    "do" "does" "did" "can" "could" "would" "should" "will" "shall"
    "to" "of" "in" "on" "at" "for" "with" "from" "by" "as" "and" "or" "but"
    "so" "if" "not" "no" "yes" "please" "just" "really" "very"
    "give" "show" "let" "know" "like")
  "Common filler words removed before pattern matching.")

(defun lowercase-string (text)
  "Convert TEXT to lowercase."
  (string-downcase text))

(defun remove-punctuation (text)
  "Remove punctuation characters from TEXT, keeping letters, digits, and spaces."
  (remove-if-not (lambda (c)
                   (or (alpha-char-p c) (digit-char-p c) (char= c #\space)))
                 text))

(defun normalize-spaces (text)
  "Collapse multiple spaces and trim leading/trailing whitespace."
  (let ((result (make-string-output-stream)))
    (let ((prev-space nil))
      (loop for c across (string-trim '(#\space #\tab) text)
            do (if (char= c #\space)
                   (unless prev-space
                     (write-char #\space result)
                     (setf prev-space t))
                   (progn
                     (write-char c result)
                     (setf prev-space nil)))))
    (get-output-stream-string result)))

(defun tokenize-string (text)
  "Split TEXT into a list of word tokens."
  (loop for start = 0 then (1+ end)
        for end = (position #\space text :start start)
        while start
        collect (subseq text start (or end (length text)))
        while end))

(defun remove-stopwords (tokens)
  "Remove common filler words from TOKENS."
  (remove-if (lambda (token) (member token *stopwords* :test #'string=))
             tokens))

(defun preprocess-text (raw-input)
  "Full NLP preprocessing pipeline: lowercase, strip punctuation,
normalize spaces, tokenize, and remove stopwords."
  (let* ((lower (lowercase-string raw-input))
         (clean (remove-punctuation lower))
         (spaced (normalize-spaces clean))
         (tokens (tokenize-string spaced)))
  (remove-stopwords tokens)))

(defun tokens-to-string (tokens)
  "Join TOKENS back into a single space-delimited string."
  (format nil "~{~a~^ ~}" tokens))
