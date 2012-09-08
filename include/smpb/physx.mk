ifndef include/smpb/physx.mk
include/smpb/physx.mk = done

include smpb/gcc.mk

CPPFLAGS +=\
	$(addprefix -isystem,$(shell find $(includedir)/physx -type d))\

CXXFLAGS +=\
	-malign-double\

LDLIBS +=\
	-Wl,--start-group\
		$(shell find $(libdir)/physx -type f -name '*.a' | grep -v CHECKED | grep -v PROFILE)\
	-Wl,--end-group\

{release}: CPPFLAGS +=\
	-DNDEBUG\

{debug}: CPPFLAGS +=\
	-D_DEBUG\

endif
