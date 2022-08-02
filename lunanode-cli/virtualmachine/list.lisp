(in-package :lunanode-cli)

(defun virtualmachine/list/print (content)
  "print virtual machines in a tabulated format"
  (let ((data (read-json content)))
    (format t "~va ~va ~va ~va~%" 37 "ID" 16 "Name" 24 "Public IP" 24 "Private IP")
    (loop for vm across (gethash "vms" data)
          do (format t "~va ~va ~va ~va~%"
                     37 (gethash "vm_id" vm)
                     16 (gethash "hostname" vm)
                     24 (gethash "primaryip" vm)
                     24 (gethash "privateip" vm)))))

(defun virtualmachine/list/handler (cmd)
  "Handler for the `list' command"
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "vm"
                      "list")))
    (virtualmachine/list/print content)))

(defun virtualmachine/list/command ()
  "list running virtual machines."
  (clingon:make-command
   :name "list"
   :description "list running virtual machines."
   :handler #'virtualmachine/list/handler
   :examples '(("list" . "lunanode-cli virtualmachine list"))))
