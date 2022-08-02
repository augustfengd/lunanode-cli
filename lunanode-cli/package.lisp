(defpackage :lunanode-cli
  (:use :cl :local-time :shasht :dexador :ironclad)
  (:shadowing-import-from :common-lisp :get :delete) ;; https://stackoverflow.com/a/49967164/12949640
  (:export :main))

(in-package :lunanode-cli)

(defun get-from-credentials-file (credentials-file k) ;; TODO: find a better place to put this.
  (with-open-file (s credentials-file :if-does-not-exist nil)
    (when s (gethash k (shasht:read-json s)))))
