
CPPFLAGS +=\
	$(foreach *,$(shell find $(DESTDIR)/include/physx -type d),-isystem$*)\

CXXFLAGS +=\
	-malign-double\

LDLIBS +=\
	-Wl,--start-group\
		$(shell find $(DESTDIR)/lib/physx -type f -name '*.a' | grep -v CHECKED | grep -v PROFILE)\
	-Wl,--end-group\

.release: CPPFLAGS +=\
	-DNDEBUG\

.debug: CPPFLAGS +=\
	-D_DEBUG\

