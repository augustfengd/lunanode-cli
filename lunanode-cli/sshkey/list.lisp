(in-package :lunanode-cli)

(defun sshkey/list/handler (cmd)
  "Handler for the `list' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
                      "sshkey"
                      "list")))
    (format t "~a" content)))

(defun sshkey/list/command ()
  "list available sshkey."
  (clingon:make-command
   :name "list"
   :description "list sshkeys."
   :handler #'sshkey/list/handler
   :examples '(("list" . "lunanode-cli sshkey list"))))
