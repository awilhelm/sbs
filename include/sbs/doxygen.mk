ifndef include/sbs/doxygen.mk
include/sbs/doxygen.mk = done

include sbs/base.mk

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
