;;;; api_handlers.lisp
;;;; HTTP routes for the website chatbot API (loaded after Hunchentoot).

(in-package :cl-user)

(defun hunchentoot-symbol (name)
  (find-symbol name :hunchentoot))

(defun request-body ()
  (let ((raw-fn (hunchentoot-symbol "RAW-POSTDATA"))
        (request (symbol-value (hunchentoot-symbol "*REQUEST*"))))
    (when (and raw-fn request)
      (funcall raw-fn :request request))))

(defun url-decode-safe (value)
  (let ((decoder (hunchentoot-symbol "URL-DECODE")))
    (if decoder
        (funcall decoder value)
        value)))

(defun parse-form-field (body field)
  (when (and body (plusp (length body)))
    (let* ((needle (format nil "~a=" field))
           (start (search needle body :test #'char-equal)))
      (when start
        (let* ((value-start (+ start (length needle)))
               (value-end (position #\& body :start value-start)))
          (url-decode-safe (subseq body value-start (or value-end (length body)))))))))

(defun read-post-field (field)
  (let* ((request (symbol-value (hunchentoot-symbol "*REQUEST*")))
         (post-params (when request
                        (let ((fn (hunchentoot-symbol "POST-PARAMETERS")))
                          (when fn (funcall fn request)))))
         (from-post (when post-params
                      (cdr (assoc field post-params :test #'string=)))))
    (or (hunchentoot:get-parameter field)
        from-post
        (parse-form-field (request-body) field))))

(defun read-request-message ()
  (read-post-field "message"))

(defun apply-site-context-from-request ()
  (merge-site-context
   :about-heading (read-post-field "about_heading")
   :about-description (read-post-field "about_description")
   :about-highlights (read-post-field "about_highlights")
   :contact-phone (read-post-field "contact_phone")
   :contact-whatsapp (read-post-field "contact_whatsapp")
   :contact-email (read-post-field "contact_email")
   :contact-address (read-post-field "contact_address")
   :services-summary (read-post-field "services_summary")
   :tagline (read-post-field "tagline")))

(defun apply-ticket-context-from-request ()
  (merge-ticket-context
   :has-open-ticket (read-post-field "has_open_ticket")
   :active-ticket-number (read-post-field "active_ticket_number")
   :active-ticket-status (read-post-field "active_ticket_status")
   :active-ticket-subject (read-post-field "active_ticket_subject")
   :active-ticket-last-update (read-post-field "active_ticket_last_update")
   :active-ticket-escalated (read-post-field "active_ticket_escalated")
   :referenced-ticket-number (read-post-field "referenced_ticket_number")))

(defun apply-conversation-context-from-request ()
  (merge-conversation-context
   :has-welcomed (read-post-field "has_welcomed")
   :client-hour (read-post-field "client_hour")))

(defun apply-chat-context-from-request ()
  (apply-site-context-from-request)
  (apply-ticket-context-from-request)
  (apply-conversation-context-from-request))

(defun demo-mode-requested? ()
  (or (string= (hunchentoot:get-parameter "demo") "true")
      (string= (hunchentoot:get-parameter "demo") "1")
      (string= (parse-form-field (request-body) "demo") "true")
      (string= (parse-form-field (request-body) "demo") "1")))

(defun enable-cors ()
  "Allow Firebase Hosting (https) to call this local API, including Chrome PNA."
  (setf (hunchentoot:header-out "Access-Control-Allow-Origin") "*")
  (setf (hunchentoot:header-out "Access-Control-Allow-Methods") "GET, POST, OPTIONS")
  (setf (hunchentoot:header-out "Access-Control-Allow-Headers")
        "Content-Type, Accept, Authorization, Access-Control-Request-Private-Network")
  (setf (hunchentoot:header-out "Access-Control-Allow-Private-Network") "true")
  (setf (hunchentoot:header-out "Access-Control-Max-Age") "86400"))

(hunchentoot:define-easy-handler (api-health :uri "/api/health"
                                             :default-request-type :get) ()
  (enable-cors)
  (setf (hunchentoot:content-type*) "application/json; charset=utf-8")
  "{\"status\":\"ok\",\"service\":\"mfloat-ai-chatbot\"}")

(hunchentoot:define-easy-handler (api-ping :uri "/api/ping"
                                           :default-request-type :get) ()
  (enable-cors)
  (setf (hunchentoot:content-type*) "application/json; charset=utf-8")
  "{\"ping\":\"pong\",\"service\":\"mfloat-ai-chatbot\"}")

(hunchentoot:define-easy-handler (api-ping-options :uri "/api/ping"
                                                   :default-request-type :options) ()
  (enable-cors)
  (setf (hunchentoot:return-code*) 204)
  "")

(hunchentoot:define-easy-handler (api-chat-options :uri "/api/chat"
                                                   :default-request-type :options) ()
  (enable-cors)
  (setf (hunchentoot:return-code*) 204)
  "")

(hunchentoot:define-easy-handler (api-health-options :uri "/api/health"
                                                     :default-request-type :options) ()
  (enable-cors)
  (setf (hunchentoot:return-code*) 204)
  "")

(hunchentoot:define-easy-handler (api-chat :uri "/api/chat"
                                           :default-request-type :post
                                           :default-parameter-type 'string) ()
  (enable-cors)
  (setf (hunchentoot:content-type*) "application/json; charset=utf-8")
  (handler-case
      (let ((message (string-trim '(#\space #\tab #\return #\newline)
                                  (or (read-request-message) ""))))
        (if (plusp (length message))
            (progn
              (apply-chat-context-from-request)
              (multiple-value-bind (intent response processed patterns trace)
                  (process-chat-message message :demo (demo-mode-requested?))
                (build-chat-json message intent response processed patterns trace)))
            (progn
              (setf (hunchentoot:return-code*) 400)
              "{\"error\":\"Message is required\"}")))
    (error (condition)
      (setf (hunchentoot:return-code*) 500)
      (format nil "{\"error\":~a}" (json-string (format nil "~a" condition))))))
