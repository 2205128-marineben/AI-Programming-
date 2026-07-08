;;;; test_queries.lisp
;;;; Automated test suite aligned with MFloat Tech website content.

(in-package :cl-user)

(defvar *test-results* nil)

(defun load-test-site-context ()
  (set-site-context
   :about-heading "Who We Are"
   :about-description "MFloat Tech Communications is a modern technology company focused on building reliable, scalable, and intelligent digital solutions for businesses, organizations, and growing enterprises."
   :about-highlights "Software Development, System Integration, Digital Automation, Communication Technologies, Technical Support"
   :contact-phone "+254 729 137 818"
   :contact-whatsapp "+254 729 137 818"
   :contact-email "mfloat.team@gmail.com"
   :contact-address "Kenya"
   :services-summary "1. Custom Software Development — tailored software systems. 2. System Maintenance & Technical Support — ongoing maintenance. 3. System Integration Services — payment and API integration. 4. Web & Digital Solutions — websites and portals. 5. ICT Consultancy — technology planning."
   :tagline "Building Reliable, Scalable & Intelligent Digital Solutions for Businesses"))

(defparameter *test-cases*
  '(("Hello"                          GREETING)
    ("Hi there"                       GREETING)
    ("Goodbye"                        EXIT)
    ("Help"                           HELP)
    ("Thank you"                      THANK_YOU)
    ("Yes"                            AFFIRMATIVE)
    ("Sure"                           AFFIRMATIVE)
    ("Tell me about this website"     COMPANY_INFO)
    ("What is M-Float?"               COMPANY_INFO)
    ("Tell me about the company"      COMPANY_INFO)
    ("Who are you?"                   COMPANY_INFO)
    ("Where are you located?"         COMPANY_LOCATION)
    ("Contact support"                CONTACT_INFO)
    ("Phone number"                   CONTACT_INFO)
    ("What services do you offer?"    SERVICES_OVERVIEW)
    ("Custom software development"    SOFTWARE_DEVELOPMENT)
    ("System maintenance"             SYSTEM_MAINTENANCE)
    ("System integration"             SYSTEM_INTEGRATION)
    ("Website development"            WEB_DIGITAL)
    ("ICT consultancy"                  ICT_CONSULTANCY)
    ("Why choose you?"                  WHY_CHOOSE_US)
    ("Development process"            DEVELOPMENT_PROCESS)
    ("Which industries do you serve?" INDUSTRIES)
    ("Vision and mission"             VISION_MISSION)
    ("Get a quote"                      GET_QUOTE)
    ("Show me your portfolio"         PORTFOLIO)
    ("Technical support"              TECHNICAL_SUPPORT)
    ("File a complaint"               COMPLAINTS)
    ("Data security"                    SECURITY)
    ("Where are your offices located?" COMPANY_LOCATION)
    ("Company email?"                   CONTACT_INFO)
    ("Contact person"                   CONTACT_INFO)
    ("Do you have any careers available?" CAREERS)
    ("Any updates?"                     TICKET_UPDATES)
    ("Check status of my request"       CHECK_TICKET_STATUS)
    ("Speak to agent"                   REQUEST_AGENT)
    ("Escalate this issue"              ESCALATE_TICKET)
    ("This is frustrating"              FRUSTRATED)
    ("What is the weather today?"     UNKNOWN)))
  (multiple-value-bind (intent response)
      (process-single-query input)
    (declare (ignore response))
    (let ((passed (eq intent expected)))
      (push (list :input input :expected expected :actual intent :passed passed)
            *test-results*)
      (values passed intent))))

(defun run-all-tests ()
  (load-test-site-context)
  (setf *test-results* nil)
  (format t "~%============================================================~%")
  (format t "   M-Float AI Chatbot — Test Suite~%")
  (format t "============================================================~%~%")
  (let ((passed 0)
        (failed 0))
    (dolist (test-case *test-cases*)
      (let* ((input (first test-case))
             (expected (second test-case)))
        (multiple-value-bind (ok actual)
            (run-single-test input expected)
          (if ok
              (progn
                (incf passed)
                (format t "[PASS] ~a -> ~a~%" input (intent-display-name expected)))
              (progn
                (incf failed)
                (format t "[FAIL] ~a -> expected ~a, got ~a~%"
                        input (intent-display-name expected)
                        (intent-display-name actual)))))))
    (format t "~%------------------------------------------------------------~%")
    (format t "Results: ~d passed, ~d failed, ~d total~%"
            passed failed (length *test-cases*))
    (format t "============================================================~%~%")
    (= failed 0)))
