(asdf:defsystem :lunanode-cli
  :name "lunanode-cli"
  :long-name "lunanode-cli"
  :description "A command-line interface program for lunanode cloud services."
  :version "0.0.1"
  :author "August Feng <augustfengd@gmail.com>"
  :maintainer "August Feng <augustfengd@gmail.com>"
  :license "BSD 2-Clause"
  :homepage "https://github.com/augustfengd/lunanode-cli"
  :bug-tracker "https://github.com/augustfengd/lunanode-cli"
  :source-control "https://github.com/augustfengd/lunanode-cli"
  :depends-on (:clingon :dexador :local-time :ironclad :shasht)
  :components ((:module "lunanode-cli"
                :serial t
                :components ((:file "package")
                             (:file "api")
                             (:module "virtualmachine"
                              :components
                              ((:file "virtualmachine")
                               (:file "create")
                               (:file "list")
                               (:file "delete")))
                             (:module "image"
                              :components
                              ((:file "image")
                               (:file "list")))
                             (:module "sshkey"
                              :components
                              ((:file "sshkey")
                               (:file "list")))
                             (:module "ssh"
                              :components
                              ((:file "ssh")))
                             (:module "billing"
                              :components
                                      ((:file "billing")))
                             (:module "completion"
                              :components
                              ((:file "completion")
                               (:file "zsh")))
                             (:file "main"))))
  :build-operation "program-op"
  :build-pathname "bin/lunanode-cli"
  :entry-point "lunanode-cli:main"
  :in-order-to ((test-op (test-op "lunanode-cli/tests"))))

(asdf:defsystem #:lunanode-cli/tests
  :depends-on (:lunanode-cli :fiveam)
  :perform (test-op (o s)
		                (uiop:symbol-call :fiveam :run!))
  :components ((:module "t"
                :serial t
                :components ((:file "main")))))
