(in-package :lunanode-cli)

(defun billing/print (content)
  "print billing credit in a tabulated format"
  (let ((data (read-json content)))
    (format t "~va~%" 5 "Credit")
    (format t "~va~%" 5 (gethash "credit" data))))

(defun billing/handler (cmd)
  "Handler for the `billing' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
                      "billing"
                      "credit")))
    (billing/print content)))

(defun billing/command ()
  "Creates a new command to interfact with lunanode's billing service."
  (clingon:make-command
   :name "billing"
   :description "interact with the billing service."
	 :handler #'billing/handler
   :examples '(("list" . "lunanode-cli billing"))))
