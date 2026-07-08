;;;; inference_engine.lisp
;;;; Rule-based inference engine — IF intent THEN action.

(in-package :cl-user)

(defparameter *inference-rules*
  '((GREETING            :respond-greeting)
    (EXIT                :respond-exit)
    (HELP                :respond-help)
    (THANK_YOU           :respond-thank-you)
    (AFFIRMATIVE         :respond-affirmative)
    (COMPANY_INFO        :respond-company-info)
    (COMPANY_LOCATION    :respond-company-location)
    (CONTACT_INFO        :respond-contact-info)
    (CAREERS             :respond-careers)
    (SERVICES_OVERVIEW   :respond-services-overview)
    (SOFTWARE_DEVELOPMENT :respond-software-development)
    (SYSTEM_MAINTENANCE  :respond-system-maintenance)
    (SYSTEM_INTEGRATION  :respond-system-integration)
    (WEB_DIGITAL         :respond-web-digital)
    (ICT_CONSULTANCY     :respond-ict-consultancy)
    (WHY_CHOOSE_US       :respond-why-choose-us)
    (DEVELOPMENT_PROCESS :respond-development-process)
    (INDUSTRIES          :respond-industries)
    (VISION_MISSION      :respond-vision-mission)
    (GET_QUOTE           :respond-get-quote)
    (PORTFOLIO           :respond-portfolio)
    (TECHNICAL_SUPPORT   :respond-technical-support)
    (COMPLAINTS          :respond-complaints)
    (REQUEST_AGENT       :respond-request-agent)
    (CREATE_TICKET       :respond-create-ticket)
    (CHECK_TICKET_STATUS :respond-check-ticket-status)
    (TICKET_UPDATES      :respond-ticket-updates)
    (ESCALATE_TICKET     :respond-escalate-ticket)
    (FRUSTRATED          :respond-frustrated)
    (SECURITY            :respond-security)
    (UNKNOWN             :respond-unknown)))

(defun get-rule-for-intent (intent)
  (cadr (assoc intent *inference-rules*)))

(defun infer-response (intent &optional normalized-message)
  (let ((*current-normalized-message*
         (or normalized-message *current-normalized-message* "")))
    (let ((action (or (get-rule-for-intent intent) :respond-unknown)))
      (generate-response action intent))))

(defun describe-inference (intent)
  (format nil "IF intent = ~a THEN ~a"
          (intent-display-name intent)
          (get-rule-for-intent intent)))

(defun list-all-rules ()
  *inference-rules*)
