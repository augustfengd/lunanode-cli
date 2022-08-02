(in-package :lunanode-cli)

(defun virtualmachine/create/options ()
  "Returns the options for the `list' command"
  (list
   (clingon:make-option :string
			                  :description "A label for this virtual machine, which will also be used as its hostname"
			                  :short-name #\h
			                  :long-name "hostname"
                        :required t
			                  :key :hostname)
   (clingon:make-option :string
			                  :description "Either a numeric ID (see plan/list), or a string ID like \"m.2\" or \"s.4\""
			                  :short-name #\p
			                  :long-name "plan-id"
                        :initial-value "m.1s"
			                  :key :plan-id)
   (clingon:make-option :string
			                  :description "An image ID"
			                  :short-name #\i
			                  :long-name "image-id"
                        :initial-value "630902" ;; "Ubuntu 22.04 64-bit (template)"
			                  :key :image-id)
   (clingon:make-option :choice
			                  :description "The region parameter applies a filter so that only images in the specified region are returned."
			                  :short-name #\r
			                  :long-name "region"
                        :initial-value "montreal"
			                  :items '("montreal" "toronto" "france")
			                  :key :region)
   (clingon:make-option :string
			                  :description "A comma-separated list of key IDs"
			                  :short-name #\k
			                  :long-name "key-id"
			                  :key :key-id)))

(defun virtualmachine/create/params (hostname plan-id image-id region key-id)
  (let ((params (list
                 (when hostname (cons "hostname" hostname))
                 (when plan-id (cons "plan_id" plan-id))
                 (when image-id (cons "image_id" image-id))
                 (when region (cons "region" region))
                 (when key-id (cons "key_id" key-id)))))
    (remove nil params)))

(defun virtualmachine/create/handler (cmd)
  "Handler for the `create' command"
  (let ((content (api (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_ID") (clingon:getopt cmd :api-id))
                      (or (get-from-credentials-file (clingon:getopt cmd :credentials-file) "API_KEY") (clingon:getopt cmd :api-key))
                      "vm"
                      "create"
                      (virtualmachine/create/params (clingon:getopt cmd :hostname)
                                                    (clingon:getopt cmd :plan-id)
                                                    (clingon:getopt cmd :image-id)
                                                    (clingon:getopt cmd :region)
                                                    (clingon:getopt cmd :key-id)))))
    (format t "~a" content)))

(defun virtualmachine/create/command ()
  "create a virtual machine."
  (clingon:make-command
   :name "create"
   :description "create a virtual machine."
   :options (virtualmachine/create/options)
   :handler #'virtualmachine/create/handler
   :examples '(("create" . "lunanode-cli virtualmachine create"))))
