;;;; site_context.lisp
;;;; Dynamic website content injected from the M-Float React site (Firebase).

(in-package :cl-user)

(defvar *site-context* nil
  "Website content from the live site, set on each API request.")

(defun clear-site-context ()
  (setf *site-context* nil))

(defun set-site-context (&key about-heading about-description about-highlights
                            contact-phone contact-whatsapp contact-email contact-address
                            services-summary tagline)
  (setf *site-context*
        (list :about-heading about-heading
              :about-description about-description
              :about-highlights about-highlights
              :contact-phone contact-phone
              :contact-whatsapp contact-whatsapp
              :contact-email contact-email
              :contact-address contact-address
              :services-summary services-summary
              :tagline tagline)))

(defun non-empty-string-p (value)
  (and value (stringp value) (plusp (length (string-trim '(#\space) value)))))

(defun merge-site-context (&key about-heading about-description about-highlights
                             contact-phone contact-whatsapp contact-email contact-address
                             services-summary tagline)
  "Update only fields that were provided with non-empty values."
  (let ((updates (list :about-heading about-heading
                       :about-description about-description
                       :about-highlights about-highlights
                       :contact-phone contact-phone
                       :contact-whatsapp contact-whatsapp
                       :contact-email contact-email
                       :contact-address contact-address
                       :services-summary services-summary
                       :tagline tagline))
        (current (or *site-context* '())))
    (setf *site-context*
          (loop for key in '(:about-heading :about-description :about-highlights
                             :contact-phone :contact-whatsapp :contact-email
                             :contact-address :services-summary :tagline)
                for value = (getf updates key)
                append (list key
                             (if (non-empty-string-p value)
                                 value
                                 (getf current key)))))))

(defun site-field (key)
  "Return a website field from the current context, or NIL."
  (when *site-context*
    (let ((value (getf *site-context* key)))
      (when (and value (stringp value) (plusp (length (string-trim '(#\space) value))))
        value))))

(defun site-context-available-p ()
  (and *site-context* (site-field :about-description)))
