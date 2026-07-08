;;;; response_generator.lisp
;;;; Response generator — retrieves and formats knowledge base responses.

(in-package :cl-user)

(load (merge-pathnames "knowledge_base.lisp" *load-pathname*))

(defun generate-response (action intent)
  "Generate a response string based on ACTION keyword and INTENT.
Looks up content from the knowledge base."
  (declare (ignore action))
  (get-response-for-intent intent))

