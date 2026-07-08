;;;; nlp.lisp
;;;; Natural Language Processing module — orchestrates the preprocessing pipeline.

(in-package :cl-user)

(load (merge-pathnames "tokenizer.lisp" *load-pathname*))

(defun process-user-input (raw-input)
  "Accept raw user text and return processed tokens for pattern matching.
Uses the full normalized text (with stopwords) for phrase matching accuracy."
  (let* ((lower (lowercase-string raw-input))
         (clean (remove-punctuation lower))
         (spaced (normalize-spaces clean))
         (tokens (remove-stopwords (tokenize-string spaced))))
    (list :tokens tokens :normalized spaced :raw raw-input)))

(defun describe-nlp-pipeline (processed)
  "Return a human-readable trace of NLP steps for demonstration mode."
  (list (format nil "Raw input: ~a" (getf processed :raw))
        (format nil "Normalized text: ~a" (getf processed :normalized))
        (format nil "Tokens: ~a" (getf processed :tokens))))
