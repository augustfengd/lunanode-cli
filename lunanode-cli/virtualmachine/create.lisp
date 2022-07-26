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
                        :required t
			                  :key :plan-id)
   (clingon:make-option :string
			                  :description "An image ID"
			                  :short-name #\i
			                  :long-name "image-id"
                        :required t
			                  :key :image-id)
   (clingon:make-option :choice
			                  :description "The region parameter applies a filter so that only images in the specified region are returned."
			                  :short-name #\r
			                  :long-name "region"
			                  :env-vars '("REGION")
			                  :items '("montreal" "toronto" "france")
			                  :key :region)
   (clingon:make-option :string
			                  :description "A comma-separated list of key IDs"
			                  :short-name #\k
			                  :long-name "key-id"
			                  :key :key-id)))

(defun virtualmachine/create/params (hostname plan-id image-id region key-id)
  (list
   (if hostname (cons "hostname" hostname))
   (if plan-id (cons "plan_id" plan-id))
   (if image-id (cons "image_id" image-id))
   (if region (cons "region" region))
   (if key-id (cons "key_id" key-id))))

(defun virtualmachine/create/handler (cmd)
  "Handler for the `create' command"
  (let ((content (api (clingon:getopt cmd :api-id)
                      (clingon:getopt cmd :api-key)
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
