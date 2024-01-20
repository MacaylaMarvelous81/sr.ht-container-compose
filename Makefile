.PHONY: init
init:
	[ -e core.sr.ht ] || git clone --recurse-submodules https://git.sr.ht/~sircmpwn/core.sr.ht
	[ -e meta.sr.ht ] || git clone https://git.sr.ht/~sircmpwn/meta.sr.ht
	[ -e todo.sr.ht ] || git clone https://git.sr.ht/~sircmpwn/todo.sr.ht
	[ -e scm.sr.ht ] || git clone https://git.sr.ht/~sircmpwn/scm.sr.ht
	[ -e git.sr.ht ] || git clone https://git.sr.ht/~sircmpwn/git.sr.ht
