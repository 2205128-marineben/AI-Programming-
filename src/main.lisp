;;;; main.lisp
;;;; Entry point for the M-Float AI Customer Support Assistant.

(in-package :cl-user)

(defvar *src-directory*
  (make-pathname :directory (pathname-directory *load-pathname*))
  "Directory containing all source modules.")

(defun load-module (filename)
  "Load a LISP source file from the src directory."
  (load (merge-pathnames filename *src-directory*)))

;;; Load modules in dependency order
(load-module "knowledge_base.lisp")
(load-module "tokenizer.lisp")
(load-module "nlp.lisp")
(load-module "response_generator.lisp")
(load-module "pattern_matcher.lisp")
(load-module "inference_engine.lisp")
(load-module "chatbot.lisp")
(load-module "website_content.lisp")
(load-default-website-content)

(defun main (&optional demo-flag)
  "Start the M-Float AI chatbot.
Usage: (main)       — interactive mode
       (main :demo) — demonstration mode with reasoning traces"
  (start-chatbot :demo (eq demo-flag :demo)))

(defun run-tests ()
  "Load and execute the test suite."
  (load (merge-pathnames "../tests/test_queries.lisp" *load-pathname*))
  (run-all-tests))

(defun script-args ()
  "Return command-line arguments (excluding the program name)."
  #+sbcl (rest sb-ext:*posix-argv*)
  #-sbcl '())

(defvar *web-port* 8766)

(defun ensure-hunchentoot ()
  "Load Quicklisp and Hunchentoot before the web server module."
  (unless (find-package :hunchentoot)
    (let ((setup (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
      (unless (probe-file setup)
        (error "Quicklisp not found. Install from https://www.quicklisp.org/"))
      (load setup)
      (funcall (intern "QUICKLOAD" :ql) :hunchentoot))))

(defun start-web (&optional port)
  "Start the browser-based chat interface."
  (ensure-hunchentoot)
  (load-module "website_content.lisp")
  (load-default-website-content)
  (load-module "web_server.lisp")
  (start-web-server :port (or port *web-port*)))

(defun handle-script-args ()
  "Process command-line flags when run as: sbcl --script main.lisp [--test|--demo|--web]"
  (let ((args (script-args)))
    (cond
      ((member "--test" args :test #'string=)
       (let ((ok (run-tests)))
         #+sbcl (sb-ext:quit :unix-status (if ok 0 1))))
      ((member "--web" args :test #'string=)
       (let ((port-pos (position "--port" args :test #'string=)))
         (start-web (when port-pos (parse-integer (nth (1+ port-pos) args) :junk-allowed t)))))
      ((member "--demo" args :test #'string=)
       (main :demo))
      (t (main)))))

(handle-script-args)
