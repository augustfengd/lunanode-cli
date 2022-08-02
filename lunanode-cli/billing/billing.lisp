(in-package :lunanode-cli)

(defun billing/credit/print (content)
  "print billing credit in a tabulated format"
  (let ((data (read-json content)))
    (format t "~va~%" 5 "Credit")
    (format t "~va~%" 5 (gethash "credit" data))))

(defun billing/credit/handler (cmd)
  "Handler for the `billing' command"
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "billing"
                      "credit")))
    (billing/credit/print content)))

(defun billing/credit/command ()
  "Creates a new command to interfact with lunanode's billing service."
  (clingon:make-command
   :name "billing"
   :description "interact with the billing service."
	 :handler #'billing/credit/handler
   :examples '(("billing" . "lunanode-cli billing"))))
