ifndef include/sbs/git.mk
include/sbs/git.mk = done

GIT_DIR := $(shell cd $(srcdir) && cd $$(git rev-parse --git-dir) && pwd)

version.mk: $(GIT_DIR)/HEAD; cd $(<D) && git describe --tags --match 'v[0-9]*' | sed 's/./version := /; y/-/./; s/.[^.]*$//' >$@

endif
