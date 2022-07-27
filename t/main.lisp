(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:fiveam :shasht :py4cl2) :silent t))

(defpackage :lunanode-cli/tests
  (:use :cl :fiveam)
  (:export :run!))

(fiveam:test build-handler
  (let ((handler (lunanode-cli::build-handler "vm" "create"))
        (expected "vm/create/"))
    (fiveam:is (equalp
                handler
                expected))))

(fiveam:test build-nonce
  (let ((nonce (lunanode-cli::build-nonce))
        (expected (progn (py4cl2:pyexec "import time") ;; HACK: will fail if python's response returns too late.
                         (py4cl2:pyeval "str(int(time.time()))"))))
    (fiveam:is (equalp
                nonce
                expected))))

(fiveam:test build-req
  (let ((req (lunanode-cli::build-req "abcdefghijklmnop" "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwx"))
        (expected "{\"api_id\":\"abcdefghijklmnop\",\"api_partialkey\":\"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl\"}"))
    (fiveam:is (equalp
                req
                expected))))

(fiveam:test build-hash
  (let ((hash (lunanode-cli::build-hash "abcdefghijklmnop"))
        (hex-string-digest "f622031300f3c1b9161972bd7b22ee43d75f42b8234b30f91d54a7fd7268a64f871bb93dede4591a2093fad623aee899031692496485aa41c92385041e5ef442"))
    (fiveam:is (equalp
                (ironclad:byte-array-to-hex-string (ironclad:hmac-digest hash))
                hex-string-digest))))

(fiveam:test build-message
  (let ((message (lunanode-cli::build-message
                  "vm/create/"
                  "{\"api_id\":\"abcdefghijklmnop\",\"api_partialkey\":\"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl\"}"
                  "775886400"))
        (expected (ironclad:ascii-string-to-byte-array "vm/create/|{\"api_id\":\"abcdefghijklmnop\",\"api_partialkey\":\"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl\"}|775886400")))
    (fiveam:is (equalp
                message
                expected))))

(fiveam:test update-hash
  (let ((hash (ironclad:make-hmac (ironclad:ascii-string-to-byte-array "abcdefghijklmnop") :sha512))
        (message (ironclad:ascii-string-to-byte-array "vm/create/|{\"api_id\":\"abcdefghijklmnop\",\"api_partialkey\":\"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl\"}|775886400")))
    (let ((hash (lunanode-cli::update-hash hash message))
          (expected (ironclad:update-hmac hash message)))
      (fiveam:is (equalp
                  (ironclad:hmac-digest hash)
                  (ironclad:hmac-digest expected))))))

(fiveam:test build-signature
  (let ((api-id "abcdefghijklmnop")
        (api-key "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwx")
        (category "vm")
        (action "create")
        (nonce "775886400"))
    (fiveam:is (typep
                (lunanode-cli::build-signature api-id api-key category action nonce)
                'ironclad:hmac))))

(fiveam:test build-signature-digest
  (let ((api-id "abcdefghijklmnop")
        (api-key "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwx")
        (category "vm")
        (action "create")
        (nonce "775886400"))
    (let ((signature (lunanode-cli::build-signature-digest (lunanode-cli::build-signature api-id api-key category action nonce)))
          (expected "183236c9a4635699e454236733a86045857818fa96f1631d1a68550a2277510ccd782fcfb15ea67d035fdfd2b3f7205258d15f72051a1e4d6f6d1d54a6b69997"))
      (fiveam:is (equalp
                  signature
                  expected)))))

(fiveam:test build-request-body
  (let ((api-id "abcdefghijklmnop")
        (api-key "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwx")
        (category "vm")
        (action "list")
        (nonce "775886400"))
    (let ((body (lunanode-cli::build-request-body api-id api-key category action nonce))
          (expected '(("req"
                       . "{\"api_id\":\"abcdefghijklmnop\",\"api_partialkey\":\"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl\"}")
                      ("signature"
                       . "af5b7ba795e6a65fd12ea80343652ce3de1008972cff6e28185043915ac6c6152e50a931c8ec054f416226b162d21ad7c4461dc2953448f5e743bcf41cdd46c9")
                      ("nonce" . "775886400"))))
      (fiveam:is (equalp
                  body
                  expected)))))

(fiveam:test virtualmachine/list/print
  (let ((content "{\"vms\":[{\"vm_id\":\"81ebdd9e-178f-49a4-816b-a1fc46fc5869\",\"name\":\"foobar\",\"plan_id\":\"123\",\"hostname\":\"foobar\",\"primaryip\":\"1.1.1.1\",\"privateip\":\"1.1.1.1\",\"ram\":\"1024\",\"vcpu\":\"1\",\"storage\":\"15\",\"bandwidth\":\"1000\",\"region\":\"montreal\",\"os_status\":\"active\"}],\"success\":\"yes\"}"))
    (fiveam:is (stringp (lunanode-cli::virtualmachine/list/print content))))) ;; TODO: may be difficult to test this function as the output is a side effect.
