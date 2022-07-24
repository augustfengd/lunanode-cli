(in-package :lunanode-cli)

(defun virtualmachine/sub-commands ()
  "Returns the list of sub-commands for the top-level command"
  (list
   (virtualmachine/create/command)
   (virtualmachine/list/command)
   (virtualmachine/delete/command)))

(defun virtualmachine/handler (cmd)
  "Handler for the `virtualmachine' command"
  (clingon:print-usage-and-exit cmd t))

(defun virtualmachine/command () ;; this command needs to nest into subcommands.
  "Creates a new command to interfact with lunanode's virtual machine service."
  (clingon:make-command
   :name "virtualmachine"
   :description "interact with the virtual machine service."
	 :handler #'virtualmachine/handler
   :sub-commands (virtualmachine/sub-commands)
   :examples '(("create" . "lunanode-cli virtualmachine create")
               ("list" . "lunanode-cli virtualmachine list")
               ("delete" . "lunanode-cli virtualmachine delete"))))
