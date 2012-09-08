ifndef include/smpb/common.mk
include/smpb/common.mk = done

prefix = $(PWD)/$(arch.$(do))
bindir = $(prefix)/bin
datadir = $(prefix)/share
includedir = $(prefix)/include
libdir = $(prefix)/lib

makefile := $(realpath $(firstword $(MAKEFILE_LIST)))

makefilepath = $(foreach *,$1,$(realpath $(dir $*)$(firstword $(notdir $(wildcard $* $*/makefile)))))

endif
