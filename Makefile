LISP := sbcl

bin/lunanode-cli: lunanode-cli lunanode-cli/virtualmachine lunanode-cli/image lunanode-cli/sshkey lunanode-cli/ssh lunanode-cli/billing lunanode-cli/completion lunanode-cli.asd
	CL_SOURCE_REGISTRY=$(PWD) $(LISP) --noinform \
		--eval "(ql:quickload 'lunanode-cli)" \
		--eval '(asdf:make :lunanode-cli)'  \
		--eval '(quit)'

.PHONY: install
install: bin/lunanode-cli
	cp $< $(HOME)/.local/bin/lunanode-cli

.PHONY: tests
tests:
	CL_SOURCE_REGISTRY=$(PWD) $(LISP) --noinform --eval "(asdf:test-system 'lunanode-cli)" --eval "(sb-ext:quit)"
