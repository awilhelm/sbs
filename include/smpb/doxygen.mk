ifndef include/smpb/doxygen.mk
include/smpb/doxygen.mk = done

include smpb/base.mk

%/doxyfile.done: %/doxyfile | %/dir/..
	cd $(@D) && { $(foreach *,$(DOXYFILE),echo $*;) } | cat - $< | doxygen - #$(tag)
	@ touch $@

%.qch: %.qhp; qhelpgenerator $< -o $@ >/dev/null #$(tag)

%.qhp: ; @:

DOXYFILE +=\
	INPUT=$(srcdir)\
	STRIP_FROM_PATH=$(srcdir)\

{debug}: DOXYFILE +=\
	INTERNAL_DOCS=YES\

endif
