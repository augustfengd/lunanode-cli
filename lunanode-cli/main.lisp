(in-package :lunanode-cli)

(defparameter *URL_ROOT* "https://dynamic.lunanode.com/api/~a/~a/")

(defun top-level/sub-commands ()
  "Returns the list of sub-commands for the top-level command"
  (list
   (virtualmachine/command)
   (image/command)
   (sshkey/command)
   (ssh/command)
   (completion/command)))

(defun top-level/options ()
  "Returns the options for the top-level command"
  (list
   (clingon:make-option :string
                        :description "API ID"
                        :long-name "api-id"
			                  :env-vars '("API_ID")
                        :key :api-id)
   (clingon:make-option :string
                        :description "API KEY"
                        :long-name "api-key"
			                  :env-vars '("API_KEY")
                        :key :api-key)))

(defun top-level/handler (cmd)
  "The handler for the top-level command. Will print the usage of the app"
  (clingon:print-usage-and-exit cmd t))

(defun top-level/command ()
  "Returns the top-level command"
  (clingon:make-command :name "lunanode-cli"
                        :version "0.1.0"
                        :description "A command-line interface program for interacting with lunanode cloud services."
                        :long-description (format nil "A CLI program for interfacing  ~
                                                       with lunanode cloud services.")
                        :authors '("August Feng <augustfengd@gmail.com>")
                        :license "BSD 2-Clause"
                        :options (top-level/options)
			                  :handler #'top-level/handler
                        :sub-commands (top-level/sub-commands)))

(defun main ()
  "The main entrypoint for lunanode-cli."
  (let ((app (top-level/command)))
    (clingon:run app)))
