(defpackage :lunanode-cli
  (:use :cl :local-time :shasht :dexador :ironclad)
  (:shadowing-import-from :common-lisp :get :delete) ;; https://stackoverflow.com/a/49967164/12949640
  (:export :main))

(in-package :lunanode-cli)
