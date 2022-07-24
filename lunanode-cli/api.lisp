(in-package :lunanode-cli)

(defun build-handler (category action)
  (format nil "~a/~a/" category action))

(defun build-nonce ()
  (let ((epoch-time (local-time:timestamp-to-unix (local-time:now))))
    (write-to-string epoch-time)))

(defun build-req (api-id api-key &optional params)
  (declare (ignorable params))
  (let ((credentials (list (cons "api_id" api-id)
                           (cons "api_partialkey" (subseq api-key 0 64)))))
    (shasht:write-json* (append credentials params) :stream nil :alist-as-object t :pretty nil)))

(defun build-hash (api-key)
  (ironclad:make-hmac (ironclad:ascii-string-to-byte-array api-key) :sha512))

(defun build-message (handler req nonce)
  (ironclad:ascii-string-to-byte-array (format nil "~a|~a|~a" handler req nonce)))

(defun update-hash (hash message)
  (ironclad:update-hmac hash message))

(defun build-signature-digest (hash)
  (ironclad:byte-array-to-hex-string (ironclad:hmac-digest hash)))

(defun build-signature (api-id api-key category action nonce &optional params)
  (let ((hash (build-hash api-key))
        (message (build-message
                  (build-handler category action)
                  (build-req api-id api-key params)
                  nonce)))
    (ironclad:update-hmac hash message)))

(defun build-request-body (api-id api-key category action nonce &optional params)
  (declare (ignorable params))
  (list
   (cons "req" (build-req api-id api-key params))
   (cons "signature" (build-signature-digest (build-signature api-id api-key category action nonce params)))
   (cons "nonce" nonce)))

(defun api (api-id api-key category action &optional params)
  (declare (ignorable params))
  (let ((url (format nil *URL_ROOT* category action))
        (body (build-request-body api-id api-key category action (build-nonce) params)))
    (dex:post url :content body)))
