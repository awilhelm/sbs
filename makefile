goals := $(notdir $(basename $(wildcard src/*.mk)))

.PHONY release debug: $(goals)
	@ echo Signature: 8a477f597d28d172789f06886806bc55 >$@/CACHEDIR.TAG

$(goals):
	@ mkdir -p $(patsubst $(VPATH)%,$(DESTDIR)/build/$@/%,$(VPATH) $(shell find $(VPATH) -type d 2>/dev/null))
	@ $(MAKE) -C $(DESTDIR)/build/$@ -f $(cwd)/header.mk -f $(CURDIR)/src/$@.mk -f $(cwd)/footer.mk DESTDIR=$(CURDIR)/$(DESTDIR)/install

export VPATH = $(CURDIR)/src/$@/

release: DESTDIR := release
debug: DESTDIR := debug


# DÉPENDANCES DES PROJETS

graph-example graph-plugins: graph


# OPTIONS DE COMPILATION GLOBALES

export CPPFLAGS +=\
	-MD\
	-MP\
	-Wall\
	-Wextra\
	-Werror\
	-I$$(DESTDIR)/include\

export CFLAGS +=\
	-std=c99\
	-march=native\
	-Wconversion\

release: CFLAGS +=\
	-O3\
	-g0\

debug: CFLAGS +=\
	-O0\
	-g3\

export CXXFLAGS +=\
	-march=native\
	-Wconversion\
	-Wdisabled-optimization\

release: CXXFLAGS +=\
	-O3\
	-g0\

debug: CXXFLAGS +=\
	-O0\
	-g3\

export FC := gfortran

export FFLAGS +=\
	-march=native\

release: FFLAGS +=\
	-O3\
	-g0\

debug: FFLAGS +=\
	-O0\
	-g3\

export LDFLAGS +=\
	-Wl,--unresolved-symbols=ignore-in-shared-libs\
	-Wl,--fatal-warnings\
	-L$$(DESTDIR)/lib\

release: LDFLAGS +=\
	-O3\
	-g0\

debug: LDFLAGS +=\
	-O0\
	-g3\

export MAKEFLAGS +=\
	--no-print-directory\


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

