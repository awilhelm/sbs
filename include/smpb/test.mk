ifndef include/smpb/test.mk
include/smpb/test.mk = done

include smpb/base.mk

all.in := $(filter %.in,$(all))
all.out.old := $(all.in:in=out.old)
all.out.new := $(all.in:in=out.new)
all.out.diff := $(all.in:in=out.diff)

recipe.in.out = $(or $(abspath $(word 2,$^)),false) <$< >$@ || { $(RM) $@; exit 1; }

%.out.old: %.in; $(recipe.in.out)

%.out.new: %.in; $(recipe.in.out)

%.diff: %.old %.new; diff $^ >$@ || { test $$? -eq 1 && mv $@ $@.fail; $(RM) $@; exit 1; }

endif
