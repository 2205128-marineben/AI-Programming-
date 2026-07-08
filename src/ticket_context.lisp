;;;; ticket_context.lisp
;;;; Active support ticket context injected from the React site.

(in-package :cl-user)

(defvar *ticket-context* nil)

(defun clear-ticket-context ()
  (setf *ticket-context* nil))

(defun set-ticket-context (&key has-open-ticket active-ticket-number active-ticket-status
                            active-ticket-subject active-ticket-last-update
                            active-ticket-escalated referenced-ticket-number)
  (setf *ticket-context*
        (list :has-open-ticket (string= has-open-ticket "true")
              :active-ticket-number active-ticket-number
              :active-ticket-status active-ticket-status
              :active-ticket-subject active-ticket-subject
              :active-ticket-last-update active-ticket-last-update
              :active-ticket-escalated (string= active-ticket-escalated "true")
              :referenced-ticket-number referenced-ticket-number)))

(defun non-empty-ticket-string-p (value)
  (and value (stringp value) (plusp (length (string-trim '(#\space) value)))))

(defun merge-ticket-context (&key has-open-ticket active-ticket-number active-ticket-status
                             active-ticket-subject active-ticket-last-update
                             active-ticket-escalated referenced-ticket-number)
  (let ((updates (list :has-open-ticket has-open-ticket
                       :active-ticket-number active-ticket-number
                       :active-ticket-status active-ticket-status
                       :active-ticket-subject active-ticket-subject
                       :active-ticket-last-update active-ticket-last-update
                       :active-ticket-escalated active-ticket-escalated
                       :referenced-ticket-number referenced-ticket-number))
        (current (or *ticket-context* '())))
    (setf *ticket-context*
          (loop for key in '(:has-open-ticket :active-ticket-number :active-ticket-status
                             :active-ticket-subject :active-ticket-last-update
                             :active-ticket-escalated :referenced-ticket-number)
                for value = (getf updates key)
                append (list key
                             (cond
                               ((eq key :has-open-ticket)
                                (if (or (string= value "true") (string= value "false"))
                                    (string= value "true")
                                    (getf current key)))
                               ((eq key :active-ticket-escalated)
                                (if (or (string= value "true") (string= value "false"))
                                    (string= value "true")
                                    (getf current key)))
                               ((non-empty-ticket-string-p value) value)
                               (t (getf current key))))))))

(defun ticket-field (key)
  (when *ticket-context*
    (let ((value (getf *ticket-context* key)))
      (cond
        ((stringp value) (if (plusp (length (string-trim '(#\space) value))) value nil))
        ((eq value t) "true")
        ((null value) nil)
        (t value)))))

(defun active-ticket-available-p ()
  (and (ticket-field :active-ticket-number)
       (ticket-field :has-open-ticket)))

(defun ticket-status-text ()
  (or (ticket-field :active-ticket-status) "Open"))

(defun ticket-aware-response (intent)
  (case intent
  (CHECK_TICKET_STATUS
   (let ((number (ticket-field :active-ticket-number))
         (status (ticket-status-text))
         (last-update (ticket-field :active-ticket-last-update)))
     (if number
         (if (string-equal status "Closed")
             (format nil "Ticket ~a is closed. ~a"
                     number (or last-update "No further updates are expected."))
             (format nil "Ticket ~a is currently in the \"~a\" status. ~a"
                     number status
                     (or last-update "No new update has been posted since the last follow up.")))
         "I do not see an active support ticket for this chat yet. Tell me your issue or ask to speak with an agent to open one.")))
  (REQUEST_AGENT
   (if (active-ticket-available-p)
       (let ((number (ticket-field :active-ticket-number))
             (status (ticket-status-text)))
         (format nil "You already have ticket ~a in \"~a\" status. I can check updates, escalate it, or connect you with an available agent." number status))
       "I can connect you with a support agent. Please describe your issue and I will open a support ticket for you."))
  (ESCALATE_TICKET
   (if (active-ticket-available-p)
       (let ((number (ticket-field :active-ticket-number)))
         (format nil "I will escalate ticket ~a with an urgent follow up to the support team." number))
       "I do not see an open ticket to escalate yet. Tell me your issue or ask for an agent so I can create one first."))
  (CREATE_TICKET
   (if (active-ticket-available-p)
       (let ((number (ticket-field :active-ticket-number)))
         (format nil "You already have an open ticket (~a). Share any new details and I will add them to your request." number))
       "Share a short description of your issue and I will open a support ticket for you."))
  (TICKET_UPDATES
   (let ((number (ticket-field :active-ticket-number))
         (status (ticket-status-text))
         (last-update (ticket-field :active-ticket-last-update)))
     (if number
         (format nil "There is no new update on ticket ~a yet. It is still showing as \"~a\", with no additional reply posted since the last follow up. ~a"
                 number status (or last-update ""))
         "I do not have a ticket on file for this chat yet.")))
  (FRUSTRATED
   (if (active-ticket-available-p)
       (let ((number (ticket-field :active-ticket-number)))
         (format nil "I understand this is frustrating. I will follow up again on ticket ~a and ask for clear remediation steps and an ETA." number))
       "I understand this is frustrating. Tell me what went wrong and I will open a support ticket or connect you with an agent."))
  (t nil)))
