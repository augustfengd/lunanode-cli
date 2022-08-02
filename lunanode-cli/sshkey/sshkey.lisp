(in-package :lunanode-cli)

(defun sshkey/sub-commands ()
  "Returns the list of sub-commands for the `sshkey' command"
  (list
   (sshkey/list/command)
   (sshkey/remove/command)))

(defun sshkey/handler (cmd)
  "Handler for the `sshkey' command"
  (clingon:print-usage-and-exit cmd t))

(defun sshkey/command () ;; this command needs to nest into subcommands.
  "Creates a new command to interfact with lunanode's sshkeys service."
  (clingon:make-command
   :name "sshkey"
   :description "interact with the sshkeys service."
   :handler #'sshkey/handler
   :sub-commands (sshkey/sub-commands)
   :examples '(("list" . "lunanode-cli sshkey list"))))
