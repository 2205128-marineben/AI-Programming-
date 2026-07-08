;;;; web_server.lisp
;;;; JSON API for the M-Float website chatbot (LISP expert system backend).

(in-package :cl-user)

(defvar *web-port* 8766)

(defun json-string (text)
  "Encode TEXT as a JSON string value."
  (with-output-to-string (out)
    (write-char #\" out)
    (loop for c across (if text (format nil "~a" text) "")
          do (case c
               (#\" (write-string "\\\"" out))
               (#\\ (write-string "\\\\" out))
               (#\newline (write-string "\\n" out))
               (#\return (write-string "\\r" out))
               (#\tab (write-string "\\t" out))
               (otherwise (write-char c out))))
    (write-char #\" out)))

(defun json-string-list (strings)
  "Encode a list of strings as a JSON array."
  (if strings
      (format nil "[~{~a~^, ~}]" (mapcar #'json-string strings))
      "[]"))

(defun build-chat-json (message intent response processed patterns &optional trace)
  (declare (ignore message))
  (format nil
          "{\"intent\":~a,\"intentLabel\":~a,\"response\":~a,\"normalized\":~a,\"tokens\":~a,\"matchedPatterns\":~a,\"trace\":~a}"
          (json-string (string-downcase (symbol-name intent)))
          (json-string (intent-display-name intent))
          (json-string response)
          (json-string (getf processed :normalized))
          (json-string-list (mapcar #'string (getf processed :tokens)))
          (json-string-list (mapcar #'string patterns))
          (if trace
              (json-string-list trace)
              "[]")))

(defun process-chat-message (message &key demo)
  "Run user MESSAGE through the AI pipeline."
  (let* ((processed (process-user-input message))
         (intent (match-intent processed))
         (response (infer-response intent (getf processed :normalized)))
         (patterns (describe-pattern-match (getf processed :normalized) intent))
         (trace (when demo
                  (format-demonstration-trace message intent response
                                              :matched-patterns patterns))))
    (values intent response processed patterns trace)))

(defun ensure-api-handlers ()
  (load (merge-pathnames "api_handlers.lisp" *src-directory*)))

(defun cloud-port ()
  "Read Render PORT from the environment, else default 8766."
  #+sbcl
  (let ((port-str (sb-ext:posix-getenv "PORT")))
    (if (and port-str (plusp (length port-str)))
        (parse-integer port-str :junk-allowed t)
        *web-port*))
  #-sbcl *web-port*)

(defun start-web-server (&key (port (cloud-port)))
  "Start the chatbot API consumed by the M-Float website."
  (ensure-api-handlers)
  (format t "~%============================================================~%")
  (format t "   M-Float AI API (for website integration)~%")
  (format t "   Listening on 0.0.0.0:~d/api/chat~%" port)
  (format t "   CORS enabled for Firebase Hosting~%")
  (format t "============================================================~%~%")
  (setf hunchentoot:*catch-errors-p* t)
  (let ((acceptor (make-instance 'hunchentoot:easy-acceptor
                                 :address "0.0.0.0"
                                 :port port)))
    (handler-case
        (progn
          (hunchentoot:start acceptor)
          (format t "API server running. Press Ctrl+C to stop.~%~%")
          (loop (sleep 3600)))
      (error (e)
        (format t "Failed to start server on port ~d: ~a~%" port e)
        (sb-ext:quit :unix-status 1)))))
