(in-package :lunanode-cli)

(defun sshkey/list/print (content)
  "print sshkey in a tabulated format"
  (let ((data (read-json content)))
    (format t "~va ~va ~va~%" 4 "ID" 16 "Name" 128 "Value")
    (loop for key being the hash-value of data
          if (typep key 'hash-table)
            do (format t "~va ~va ~va~%"
                       4 (gethash "id" key)
                       16 (gethash "name" key)
                       128 (gethash "value" key)))))

(defun sshkey/list/handler (cmd)
  "Handler for the `list' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
                      "sshkey"
                      "list")))
    (sshkey/list/print content)))

(defun sshkey/list/command ()
  "list available sshkey."
  (clingon:make-command
   :name "list"
   :description "list sshkeys."
   :handler #'sshkey/list/handler
   :examples '(("list" . "lunanode-cli sshkey list"))))
