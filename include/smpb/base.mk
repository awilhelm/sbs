ifndef include/smpb/base.mk
include/smpb/base.mk = done

include smpb/common.mk

clean = { status=$$?; $(RM) $@; exit $$status; }

tag = $$([ "$(subst $(srcdir),.,$(patsubst $(srcdir)/%,%,$(patsubst $(prefix)/%,/%,$(patsubst $(CURDIR)/%,%,$(abspath $@)))))" ])

%.date: % | %/..; @ date +'%F %T.%N' -r $< >$@ || date +'%F %T.%N' >$@ || $(clean)

.DELETE_ON_ERROR:

## GESTION DES CONFIGURATIONS

{all} $(arch): ; @:

$(lastword $(arch)): $(or $(goal),$(.DEFAULT_GOAL),{all})

$(foreach *,$(join $(addsuffix :,.DEFAULT_GOAL $(arch)),=$(arch)),$(eval $*))

## CRÉATION DES DOSSIERS

mkdir = $(foreach @,$1,$(eval $@: | $@/..))

%/. %/..:: ; @ mkdir -p $(abspath $@)

.PRECIOUS: %/. %/..

## INSTALLATION

install = $(foreach <,$1,$(foreach @,$(patsubst %,$2,$<),$(eval {all}: $@)$(eval $@: $< | $@/..)))

$(prefix)/%: ; install $< $@ #$(tag)

## DÉCOUVERTE DES SOURCES

all :=

include contents.mk

contents.mk: ; find -L $(srcdir) ! -path '*/.*' -regextype posix-basic ! -regex '.*[[:space:]].*' '(' -type d -printf '$@: %p\n%p:\n' -o -printf 'all += %P\n' ')' >$@ || $(clean) #$(tag)

VPATH = $(srcdir)

## CONSTRUCTION DES DÉPENDANCES

ifndef MAKE_RESTARTS

real depends = $(call makefilepath,$(addprefix $(dir $(makefile)),$(depends)))

$(makefile): | $(real depends); @:

$(real depends): $(patsubst %,$(prefix)/xxx%/.,$(real depends)); + $(MAKE) -C$(prefix)/xxx$@ -f$@ prefix=$(prefix) srcdir=$(@D) #$(tag)

.PHONY: $(real depends)

endif

endif
