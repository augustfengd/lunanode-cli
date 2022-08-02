(in-package :lunanode-cli)

(defun image/list/print (content)
  "print images in a tabulated format"
  (let ((data (read-json content)))
    (format t "~va ~va ~va ~va~%" 8 "ID" 64 "Name" 16 "Region" 8 "Status")
    (loop for vm across (gethash "images" data)
          do (format t "~va ~va ~va ~va~%"
                     8 (gethash "image_id" vm)
                     64 (gethash "name" vm)
                     16 (gethash "region" vm)
                     8 (gethash "status" vm)))))

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
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "image"
                      "list"
                      (image/list/params (clingon:getopt cmd :region)))))
    (image/list/print content)))

(defun image/list/command ()
  "list available images."
  (clingon:make-command
   :name "list"
   :description "list images."
   :options (image/list/options)
   :handler #'image/list/handler
   :examples '(("list" . "lunanode-cli image list"))))
