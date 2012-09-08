ifndef include/sbs/cmake.mk
include/sbs/cmake.mk = done

include sbs/base.mk

Makefile: CMakeLists.txt; cmake $(<D) $(CMAKEFLAGS) #$(tag)

%/Makefile: %/CMakeLists.txt | %/dir/..; cd $(@D) && cmake $(abspath $(<D)) $(CMAKEFLAGS) #$(tag)

CMAKEFLAGS +=\
	-DCMAKE_INSTALL_PREFIX=$(prefix)\
	-DCMAKE_VERBOSE_MAKEFILE=ON\
	-DCMAKE_RULE_MESSAGES=OFF\
	-Wno-dev\

{release}: CMAKEFLAGS +=\
	-DCMAKE_BUILD_TYPE=Release\

{debug}: CMAKEFLAGS +=\
	-DCMAKE_BUILD_TYPE=Debug\

endif
