(in-package :lunanode-cli)

(defun sshkey/remove/options ()
  "Returns the options for the `remove' command"
  (list
   (clingon:make-option :string
			                  :description "the SSH key ID"
			                  :short-name #\k
			                  :long-name "key-id"
                        :required t
			                  :key :key-id)))

(defun sshkey/remove/params (key-id)
  (list (cons "key_id" key-id)))

(defun sshkey/remove/handler (cmd)
  "Handler for the `remove' command"
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "sshkey"
                      "remove"
                      (sshkey/remove/params (clingon:getopt cmd :key-id)))))
    (format t "~a" content)))

(defun sshkey/remove/command ()
  "remove an sshkey."
  (clingon:make-command
   :name "remove"
   :description "remove an sshkey."
   :options (sshkey/remove/options)
   :handler #'sshkey/remove/handler
   :examples '(("remove" . "lunanode-cli sshkey remove"))))
