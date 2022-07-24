(in-package :lunanode-cli)

(defun completion/sub-commands ()
  "Returns the list of sub-commands for `completion' command"
  (list
   (completion/zsh/command)))

(defun completion/handler (cmd)
  "Handler for the `completion' command"
  (clingon:print-usage-and-exit cmd t))

(defun completion/command ()
  "Creates a new command to generate shell completion scripts."
  (clingon:make-command
   :name "completion"
   :description "generate shell completion scripts."
	 :handler #'image/handler
   :sub-commands (completion/sub-commands)
   :examples '(("zsh" . "lunanode-cli completion zsh"))))
