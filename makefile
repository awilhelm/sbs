goals := $(notdir $(basename $(wildcard src/*.mk)))

.PHONY release debug: $(goals)
	@ echo Signature: 8a477f597d28d172789f06886806bc55 >$@/CACHEDIR.TAG

$(goals):
	@ mkdir -p $(patsubst src/$@/%,$(mode)/build/$@/%,src/$@/ $(shell find src/$@/ -type d 2>/dev/null))
	@ $(MAKE) -C $(mode)/build/$@ -f $(cwd)/header.mk -f $(CURDIR)/src/$@.mk DESTDIR=$(CURDIR)/$(mode)/install/ VPATH=$(CURDIR)/src/$@/ -I $(cwd) .$(mode)

release: mode := release
debug: mode := debug


# DÉPENDANCES DES PROJETS

graph-example graph-plugins: graph


# PROFILS D'EXÉCUTION

export LD_LIBRARY_PATH = $(CURDIR)/$</install/lib

find binary = $(patsubst $</%,%,$(firstword $(wildcard $1)))

cmd. = cd $< && $1 $(call find binary,$(basename $(basename $(wildcard $</build/$(app)/*.o)))) $(args.$(args))
cmd.aroccam = cd $< && $1 effibox --no-prompt --no-catch -a $(call find binary,$</build/$(app)/*.so) $(args.$(args))

exec: release; $(call cmd.$(cmd), exec)
exec-dbg: debug; $(call cmd.$(cmd), exec)
gdb: debug; $(call cmd.$(cmd), gdb -q --args)
memcheck: debug; $(call cmd.$(cmd), valgrind --tool=memcheck --xml=yes --xml-file=memcheck.xml)
callgrind: release; $(call cmd.$(cmd), valgrind --tool=callgrind)
drd: debug; $(call cmd.$(cmd), G_SLICE=always-malloc valgrind --tool=drd --log-file=drd.log)
cde: release; $(call cmd.$(cmd), cde)

