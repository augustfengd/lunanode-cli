(in-package :lunanode-cli)

(defun virtualmachine/list/handler (cmd)
  "Handler for the `list' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
                      "vm"
                      "list")))
    (format t "~a" content)))

(defun virtualmachine/list/command ()
  "list running virtual machines."
  (clingon:make-command
   :name "list"
   :description "list running virtual machines."
   :handler #'virtualmachine/list/handler
   :examples '(("list" . "lunanode-cli virtualmachine list"))))
