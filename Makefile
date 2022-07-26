LISP := sbcl

bin/lunanode-cli: lunanode-cli lunanode-cli/virtualmachine lunanode-cli/image lunanode-cli/sshkey lunanode-cli/completion  lunanode-cli.asd
	$(LISP) --noinform \
		--eval "(ql:quickload 'lunanode-cli)" \
		--eval '(asdf:make :lunanode-cli)'  \
		--eval '(quit)'

.PHONY: tests
tests:
	$(LISP) --noinform --eval "(asdf:test-system 'lunanode-cli)" --eval "(sb-ext:quit)"
