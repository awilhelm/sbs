ifndef include/sbs/gcc.mk
include/sbs/gcc.mk = done

include sbs/base.mk
include $(shell find ! -path '*/.*' ! -path '* *' -name '*.d')

all.c = $(filter %.c,$(all))
all.cc = $(filter %.cc %.C %.cxx %.cpp,$(all))
all.h = $(filter %.h %.hh %.H %.hxx %.hpp,$(all))
all.f = $(filter %.f %.F,$(all))
all.s = $(filter %.s %.S,$(all))
all.o = $(addsuffix .o,$(basename $(all.c) $(all.cc) $(all.f) $(all.s)))

$(call mkdir,$(all.o))

%.elf: %.a; $(LINK.o) -Wl,--whole-archive $^ -Wl,--no-whole-archive -o $@ $(LDLIBS)

%.so: %.a; $(LINK.o) -shared -Wl,--whole-archive $^ -Wl,--no-whole-archive -o $@ $(LDLIBS)

%.a:
	@ $(RM) $@
	$(AR) rcsD $@ $^ #$(tag)

FC = gfortran

CPPFLAGS +=\
	-MMD\
	-MP\
	-MF $@.d\
	-MT '.INTERMEDIATE $@'\
	-Wall\
	-Wextra\
	-Werror\
	-iquote$(@D)\
	-iquote$(srcdir)/$(@D)\
	-I$(includedir)\
	$(if $(PKG_CONFIG_LIBRARIES),$(patsubst -I%,-isystem%,$(shell pkg-config --cflags $(PKG_CONFIG_LIBRARIES))))\
	$(tag)\

CFLAGS +=\
	-std=c99\
	-march=native\
	-Wconversion\
	-fPIC\

CXXFLAGS +=\
	-march=native\
	-Wconversion\
	-Wdisabled-optimization\
	-fPIC\

FFLAGS +=\
	-march=native\

LDFLAGS +=\
	-Wl,--unresolved-symbols=ignore-in-shared-libs\
	-Wl,--fatal-warnings\
	-L$(libdir)\
	$(if $(PKG_CONFIG_LIBRARIES),$(shell pkg-config --libs $(PKG_CONFIG_LIBRARIES)))\
	$(tag)\

{debug}: CFLAGS += -O0 -g3
{debug}: CXXFLAGS += -O0 -g3
{debug}: FFLAGS += -O0 -g3
{debug}: LDFLAGS += -O0 -g3

{release}: CFLAGS += -O3 -g0
{release}: CXXFLAGS += -O3 -g0
{release}: FFLAGS += -O3 -g0
{release}: LDFLAGS += -O3 -g0

endif
