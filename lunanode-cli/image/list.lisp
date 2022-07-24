(in-package :lunanode-cli)

;; list

(defun image/list/options ()
  "Returns the options for the `list' command"
  (list
   (clingon:make-option :choice
			                  :description "The region parameter applies a filter so that only image in the specified region are returned."
			                  :short-name #\r
			                  :long-name "region"
			                  :env-vars '("REGION")
			                  :items '("montreal" "toronto" "france")
			                  :key :region)))

(defun image/list/params (region)
  (if region (list (cons "region" region))))

(defun image/list/handler (cmd)
  "Handler for the `list' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
                      "image"
                      "list"
                      (image/list/params (clingon:getopt cmd :region)))))
    (format t "~a" content)))

(defun image/list/command ()
  "list running virtual machines."
  (clingon:make-command
   :name "list"
   :description "list images."
   :options (image/list/options)
   :handler #'image/list/handler
   :examples '(("list" . "lunanode-cli image list"))))
