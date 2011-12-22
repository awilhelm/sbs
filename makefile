goals := $(notdir $(basename $(wildcard src/*.mk)))

.PHONY release debug: $(goals)
	@ echo Signature: 8a477f597d28d172789f06886806bc55 >$@/CACHEDIR.TAG

$(goals):
	@ mkdir -p $(patsubst $(VPATH)%,$(DESTDIR)/$@/%,$(shell find $(VPATH) -type d))
	@ $(MAKE) -C $(DESTDIR)/$@ -f ../../header.mk -f ../../src/$@.mk -f ../../footer.mk

export VPATH = $(CURDIR)/src/$@/

export LD_LIBRARY_PATH := .:$(subst $() $(),:,$(goals))

release: DESTDIR := release
debug: DESTDIR := debug


# DÉPENDANCES DES PROJETS

graph-example graph-plugins: graph


# OPTIONS DE COMPILATION GLOBALES

export CPPFLAGS +=\
	-MMD\
	-MP\
	-Wall\
	-Wextra\
	-Werror\

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
	-Wl,--unresolved-symbols=ignore-in-shared-libs,--fatal-warnings\

release: LDFLAGS +=\
	-O3\
	-g0\

debug: LDFLAGS +=\
	-O0\
	-g3\

export MAKEFLAGS +=\
	--no-print-directory\


# PROFILS D'EXÉCUTION

find binary = $(patsubst $</%,%,$(firstword $(wildcard $1)))

cmd. = cd $< && $1 $(call find binary,$(basename $(basename $(wildcard $</$(app)/*.o)))) $(args.$(args))
cmd.aroccam = cd $< && $1 effibox --no-prompt --no-catch -a $(call find binary,$</$(app)/*.so) $(args.$(args))

exec: release; $(call cmd.$(cmd), exec)
gdb: debug; $(call cmd.$(cmd), gdb -q --args)
memcheck: debug; $(call cmd.$(cmd), valgrind --tool=memcheck --xml=yes --xml-file=memcheck.xml)
callgrind: release; $(call cmd.$(cmd), valgrind --tool=callgrind)
drd: debug; $(call cmd.$(cmd), G_SLICE=always-malloc valgrind --tool=drd --log-file=drd.log)
cde: release; $(call cmd.$(cmd), cde)

