;;;; greeting.lisp
;;;; Contextual greeting responses — short follow-ups and time-aware salutations.

(in-package :cl-user)

(load (merge-pathnames "conversation_context.lisp" *load-pathname*))

(defun time-period-greeting (hour)
  "Return Good morning / afternoon / evening for HOUR (0-23)."
  (cond
    ((and (>= hour 5) (< hour 12)) "Good morning")
    ((and (>= hour 12) (< hour 17)) "Good afternoon")
    (t "Good evening")))

(defun contains-phrase-p (text phrase)
  (and text phrase
       (search phrase (string-downcase text) :test #'char-equal)))

(defun matches-hi-p (text)
  (or (string-equal text "hi")
      (contains-phrase-p text "hi there")
      (contains-phrase-p text "hey")
      (contains-phrase-p text "howdy")))

(defun user-used-time-greeting-p (text)
  (or (contains-phrase-p text "good morning")
      (contains-phrase-p text "good afternoon")
      (contains-phrase-p text "good evening")))

(defun choose-greeting-salutation (normalized-text hour)
  "Mirror hello/hi, or use the correct time-of-day greeting."
  (let ((text (if normalized-text normalized-text "")))
    (cond
      ((user-used-time-greeting-p text)
       (time-period-greeting hour))
      ((contains-phrase-p text "hello")
       "Hello")
      ((matches-hi-p text)
       "Hi")
      ((contains-phrase-p text "greetings")
       "Hello")
      (t
       (time-period-greeting hour)))))

(defun short-greeting-response (normalized-text hour)
  (format nil "~a, How can I assist you today?"
          (choose-greeting-salutation normalized-text hour)))

(defun full-greeting-response ()
  (let ((tagline (site-field :tagline)))
    (if tagline
        (format nil "Welcome to MFloat Tech Communications! ~a How may I help you today?" tagline)
        "Welcome to MFloat Tech Communications! I am your AI support assistant. How may I help you today?")))

(defun contextual-greeting-response ()
  "User greetings always get a short mirrored reply.
The website widget already shows the full company welcome separately."
  (let ((text *current-normalized-message*)
        (hour (conversation-hour)))
    ;; Prefer short replies whenever we have the user's message text.
    ;; Fall back to full welcome only for empty/direct greeting generation.
    (if (and text (plusp (length (string-trim '(#\space) text))))
        (short-greeting-response text hour)
        (if (conversation-welcomed-p)
            (short-greeting-response text hour)
            (full-greeting-response)))))
