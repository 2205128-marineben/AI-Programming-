;;;; chatbot.lisp
;;;; Conversational interface and main interaction loop for the expert system.

(in-package :cl-user)

(defvar *demonstration-mode* nil
  "When T, print full AI reasoning traces for each interaction.")

(defvar *running* t
  "Conversation loop control flag.")

(defun print-banner ()
  "Display the chatbot welcome banner."
  (format t "~%")
  (format t "============================================================~%")
  (format t "   MFloat AI Customer Support Assistant~%")
  (format t "   Expert System | Rule-Based Inference | NLP~%")
  (format t "   MFloat Tech Communications~%")
  (format t "============================================================~%")
  (format t "Ask about our services, company, contact details, or support.~%")
  (format t "Type 'help' for topics, or 'goodbye' to exit.~%")
  (format t "============================================================~%~%"))

(defun print-greeting ()
  "Display the initial greeting using website content when available."
  (let ((tagline (site-field :tagline)))
    (format t "Bot: Welcome to MFloat Tech Communications!~%")
    (when tagline
      (format t "     ~a~%" tagline))
    (format t "     How may I help you today?~%~%")))

(defun user-wants-to-exit? (intent)
  (eq intent 'EXIT))

(defun ask-follow-up ()
  (format t "~%Bot: Is there anything else I can help you with?~%~%"))

(defun read-user-input ()
  (format t "You: ")
  (force-output)
  (let ((line (read-line *standard-input* nil nil)))
    (if line
        (string-trim '(#\space #\tab) line)
        "")))

(defun format-demonstration-trace (raw-input intent response &key matched-patterns)
  (let ((processed (process-user-input raw-input)))
    (list
     (format nil "User: ~a" raw-input)
     ""
     (format nil "NLP: ~a" (getf processed :normalized))
     (format nil "Tokens: ~a" (getf processed :tokens))
     ""
     (format nil "Pattern match: ~{~a~^, ~}"
             (or matched-patterns
                 (describe-pattern-match (getf processed :normalized) intent)))
     ""
     (format nil "Intent: ~a" (intent-display-name intent))
     ""
     (format nil "Inference: IF intent = ~a THEN retrieve knowledge base response"
             (intent-display-name intent))
     ""
     (format nil "Response: ~a" response))))

(defun handle-query (raw-input)
  (let* ((processed (process-user-input raw-input))
         (intent (match-intent processed))
         (response (infer-response intent (getf processed :normalized)))
         (patterns (describe-pattern-match (getf processed :normalized) intent)))
    (if *demonstration-mode*
        (dolist (line (format-demonstration-trace raw-input intent response
                                                   :matched-patterns patterns))
          (format t "~a~%" line))
        (progn
          (unless (eq intent 'UNKNOWN)
            (format t "~%[Intent detected: ~a]~%" (intent-display-name intent)))
          (format t "~%Bot: ~a~%" response)))
    (values intent response)))

(defun conversation-loop ()
  (print-banner)
  (print-greeting)
  (merge-conversation-context
   :has-welcomed "true"
   :client-hour (format nil "~d" (current-local-hour)))
  (loop while *running*
        do (let ((input (read-user-input)))
             (cond
               ((string= input "")
                (format t "~%Bot: Please type a question, or 'goodbye' to exit.~%~%"))
               (t
                (let ((intent (handle-query input)))
                  (when (user-wants-to-exit? intent)
                    (setf *running* nil)
                    (return))
                  (unless (eq intent 'EXIT)
                    (ask-follow-up))))))))

(defun start-chatbot (&key (demo nil))
  (setf *demonstration-mode* demo
        *running* t)
  (conversation-loop))

(defun process-single-query (raw-input)
  (let* ((processed (process-user-input raw-input))
         (intent (match-intent processed))
         (response (infer-response intent (getf processed :normalized))))
    (values intent response)))
