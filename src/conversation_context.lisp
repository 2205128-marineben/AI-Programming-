;;;; conversation_context.lisp
;;;; Session conversation flags from the React client or terminal chat.

(in-package :cl-user)

(defvar *conversation-context* nil)
(defvar *current-normalized-message* ""
  "User message being answered, set during inference.")

(defun clear-conversation-context ()
  (setf *conversation-context* nil
        *current-normalized-message* ""))

(defun set-conversation-context (&key has-welcomed client-hour)
  (setf *conversation-context*
        (list :has-welcomed (or has-welcomed nil)
              :client-hour client-hour)))

(defun parse-boolean-field (value)
  (or (string= value "true") (string= value "1")))

(defun parse-hour-field (value)
  (when (and value (stringp value) (plusp (length (string-trim '(#\space) value))))
    (let ((hour (parse-integer value :junk-allowed t)))
      (when (and hour (>= hour 0) (<= hour 23)) hour))))

(defun merge-conversation-context (&key has-welcomed client-hour)
  (let ((updates (list :has-welcomed has-welcomed
                       :client-hour client-hour))
        (current (or *conversation-context* '())))
    (setf *conversation-context*
          (loop for key in '(:has-welcomed :client-hour)
                for value = (getf updates key)
                append (list key
                             (case key
                               (:has-welcomed
                                (if (or (string= value "true") (string= value "false"))
                                    (parse-boolean-field value)
                                    (getf current key)))
                               (:client-hour
                                (or (parse-hour-field value)
                                    (getf current key)))))))))

(defun conversation-field (key)
  (when *conversation-context*
    (getf *conversation-context* key)))

(defun conversation-welcomed-p ()
  (eq (conversation-field :has-welcomed) t))

(defun current-local-hour ()
  (third (multiple-value-list (get-decoded-time))))

(defun conversation-hour ()
  (or (conversation-field :client-hour)
      (current-local-hour)))
