(in-package :lunanode-cli)

(defun image/sub-commands ()
  "Returns the list of sub-commands for the top-level command"
  (list
   (image/list/command)))

(defun image/handler (cmd)
  "Handler for the `image' command"
  (clingon:print-usage-and-exit cmd t))

(defun image/command () ;; this command needs to nest into subcommands.
  "Creates a new command to interfact with lunanode's images service."
  (clingon:make-command
   :name "image"
   :description "interact with the images service."
	 :handler #'image/handler
   :sub-commands (image/sub-commands)
   :examples '(("list" . "lunanode-cli image list"))))
