.release .debug: all

all.h = $(shell find $(VPATH) -name '*.h' -o -name '*.hh' -o -name '*.hpp')

all.c = $(shell find $(VPATH) -name '*.c')

all.cc = $(shell find $(VPATH) -name '*.cc' -o -name '*.C' -o -name '*.cpp')

all.f = $(shell find $(VPATH) -iname '*.f')

all.s = $(shell find $(VPATH) -iname '*.s')

all.o = $(patsubst $(VPATH)%,%.o,$(basename $(all.c) $(all.cc) $(all.f) $(all.s)))

install = $(foreach 3,$1,$(foreach 4,$(patsubst %,$(DESTDIR)/$2,$(patsubst $(VPATH)%,%,$3)),$(eval all: $4)$(eval $4: $3)))

$(DESTDIR)/%:
	@ mkdir -p $(@D)
	install $< $@

%.so:; $(LINK.o) -shared -fPIC -o $@ $^ $(LDLIBS)

%.a:; $(AR) rcs $@ $^

CPPFLAGS +=\
	-MD\
	-MP\
	-Wall\
	-Wextra\
	-Werror\
	-I$(DESTDIR)/include\

CFLAGS +=\
	-std=c99\
	-march=native\
	-Wconversion\

.release: CFLAGS +=\
	-O3\
	-g0\

.debug: CFLAGS +=\
	-O0\
	-g3\

CXXFLAGS +=\
	-march=native\
	-Wconversion\
	-Wdisabled-optimization\

.release: CXXFLAGS +=\
	-O3\
	-g0\

.debug: CXXFLAGS +=\
	-O0\
	-g3\

FC := gfortran

FFLAGS +=\
	-march=native\

.release: FFLAGS +=\
	-O3\
	-g0\

.debug: FFLAGS +=\
	-O0\
	-g3\

LDFLAGS +=\
	-Wl,--unresolved-symbols=ignore-in-shared-libs\
	-Wl,--fatal-warnings\
	-L$(DESTDIR)/lib\

.release: LDFLAGS +=\
	-O3\
	-g0\

.debug: LDFLAGS +=\
	-O0\
	-g3\

.DELETE_ON_ERROR:

include $(shell find -name '*.d')

