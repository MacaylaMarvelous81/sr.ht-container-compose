repos = core.sr.ht meta.sr.ht todo.sr.ht scm.sr.ht git.sr.ht paste.sr.ht

.PHONY: init
.ONESHELL:
init:
	@
	for repo in ${repos}; do
		[ -e $$repo ] || git clone --recurse-submodules https://git.sr.ht/~sircmpwn/$$repo
	done

.PRONY: pull
.ONESHELL:
pull:
	@
	for repo in ${repos}; do
		git -C $$repo pull
	done
