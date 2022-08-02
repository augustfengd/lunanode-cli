(in-package :lunanode-cli)

(defun plan/list/print (content) ;; TODO: need to sort the data.
  "print plans in a tabulated format"
  (let ((data (read-json content)))
    (format t "~va ~va ~va ~va ~va ~va ~va ~va~%" 24 "Category" 40 "Name" 8 "Plan ID" 24 "Price (Monthly)" 16 "RAM (MB)" 8 "vCPU" 8 "Storage" 8 "Regions")
    (loop for vm across (gethash "plans" data)
          do (format t "~va ~va ~va ~va ~va ~va ~va ~va~%"
                     24 (gethash "category" vm)
                     40 (gethash "name" vm)
                     8 (gethash "plan_id" vm)
                     24 (gethash "price_monthly_nice" vm)
                     16 (gethash "ram" vm)
                     8 (gethash "vcpu" vm)
                     8 (gethash "storage" vm)
                     8 (gethash "regions_nice" vm)))))

(defun plan/list/handler (cmd)
  "Handler for the `list' command"
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "plan"
                      "list")))
    (plan/list/print content)))

(defun plan/list/command ()
  "list available plans."
  (clingon:make-command
   :name "plan"
   :description "list pricing plans."
   :handler #'plan/list/handler
   :examples '(("plan" . "lunanode-cli plan"))))
