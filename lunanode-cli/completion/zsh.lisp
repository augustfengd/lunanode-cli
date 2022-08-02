(in-package :lunanode-cli)

(defun completion/zsh/command ()
  "Returns a command for generating Zsh completion script"
  (clingon:make-command
   :name "zsh"
   :description "generate the Zsh completion script"
   :usage ""
   :handler (lambda (cmd)
              ;; Use the parent command when generating the completions,
              ;; so that we can traverse all sub-commands in the tree.
              (let ((parent (clingon:command-parent cmd)))
                (clingon:print-documentation :zsh-completions (clingon:command-parent parent) t)))))
