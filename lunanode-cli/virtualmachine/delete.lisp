(in-package :lunanode-cli)

(defun virtualmachine/delete/options ()
  "Returns the options for the `list' command"
  (list
   (clingon:make-option :string
			                  :description "The VM UUID"
			                  :short-name #\v
			                  :long-name "vm-id"
                        :required t
			                  :key :vm-id)))

(defun virtualmachine/delete/params (vm-id)
  (list (cons "vm_id" vm-id)))

(defun virtualmachine/delete/handler (cmd)
  "Handler for the `delete' command"
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "vm"
                      "delete"
                      (virtualmachine/delete/params (clingon:getopt cmd :vm-id)))))
    (format t "~a" content)))

(defun virtualmachine/delete/command ()
  "delete a virtual machine."
  (clingon:make-command
   :name "delete"
   :description "delete a virtual machine."
   :options (virtualmachine/delete/options)
   :handler #'virtualmachine/delete/handler
   :examples '(("delete" . "lunanode-cli virtualmachine delete"))))
