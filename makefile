goals := $(notdir $(basename $(wildcard src/*.mk)))

.PHONY release debug: $(goals)

$(goals):
	@ mkdir -p $(patsubst src/$@/%,$(mode)/build/$@/%,src/$@/ $(shell find src/$@/ -type d 2>/dev/null))
	@ $(MAKE) -C $(mode)/build/$@ -f $(cwd)/header.mk -f $(CURDIR)/src/$@.mk DESTDIR=$(CURDIR)/$(mode)/install/ VPATH=$(CURDIR)/src/$@/ -I $(cwd) .$(mode)

release: mode := release
debug: mode := debug


# DÉPENDANCES DES PROJETS

graph-example graph-plugins: graph


# PROFILS D'EXÉCUTION

export LD_LIBRARY_PATH = $(CURDIR)/$</install/lib

cmd. = $(firstword $(wildcard $(basename $(basename $(wildcard $</build/$(app)/*.o))))) $(args.$(args))
cmd.aroccam = effibox --no-prompt --no-catch -a $(firstword $(wildcard $</build/$(app)/*.so)) $(args.$(args))

exec: release; exec $(cmd.$(cmd))
exec-dbg: debug; exec $(cmd.$(cmd))
gdb: debug; gdb -q --args $(cmd.$(cmd))
memcheck: debug; valgrind --tool=memcheck --xml=yes --xml-file=memcheck.xml $(cmd.$(cmd))
callgrind: release; valgrind --tool=callgrind $(cmd.$(cmd))
drd: debug; G_SLICE=always-malloc valgrind --tool=drd --log-file=drd.log $(cmd.$(cmd))
cde: release; cde $(cmd.$(cmd))

