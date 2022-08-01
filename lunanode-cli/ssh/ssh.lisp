(in-package :lunanode-cli)

(defun ssh/options ()
  "Returns the options for the `ssh' command"
  (list
   (clingon:make-option :string
			                  :description "user to log in as."
			                  :short-name #\u
			                  :long-name "user"
			                  :key :user)
   (clingon:make-option :string
			                  :description "hostname of the virtual machine."
			                  :short-name #\h
			                  :long-name "hostname"
                        :required t
			                  :key :hostname)))

(defun ssh/run (content &key user hostname)
  "ssh into the machine."
  (let ((data (read-json content)))
    (loop with login-name-args = (when user (list "-l" user))
          for virtualmachine across (gethash "vms" (read-json content))
          if (equalp (gethash "name" virtualmachine)
                     hostname)
            do (sb-ext:run-program "/usr/bin/ssh" (append login-name-args (list (gethash "primaryip" virtualmachine))) :output t :input t)
               (loop-finish))))

(defun ssh/handler (cmd)
  "Handler for the `ssh' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
                      "vm"
                      "list")))
    (ssh/run content :user (clingon:getopt cmd :user) :hostname (clingon:getopt cmd :hostname))))

(defun ssh/command ()
  "Creates a new command to ssh into virtual machines."
  (clingon:make-command
   :name "ssh"
   :description "ssh into a virtual machine."
   :options (ssh/options)
	 :handler #'ssh/handler
   :examples '(("ssh" . "lunanode-cli ssh"))))
