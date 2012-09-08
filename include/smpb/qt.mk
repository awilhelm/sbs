ifndef include/smpb/qt.mk
include/smpb/qt.mk = done

include smpb/gcc.mk

%.pre: % | %/..; @ sed 's:^[[:blank:]]*#[[:blank:]]*\(include\b.*\.\(moc\|ui\.h\)\|pragma[[:blank:]]\{1,\}once\)\b.*::' $< >$@ || $(clean)

PKG_CONFIG_LIBRARIES += QtGui QtScript QtXml

CPPFLAGS +=\
	-DQT_NO_KEYWORDS\

## GÉNÉRATION DU CODE MOC

all.moc.o = $(addsuffix .moc.o,$(all.h))

$(foreach *,$(basename $(all.cc)),$(eval .INTERMEDIATE $*.o: $*.moc))

%.moc.pre: %.pre
	$(CPP) $(CPPFLAGS) -x c++ $< -o $@~ -dI -DQ_MOC_RUN
	@ awk 'BEGIN {y = 1} $$1 == "#" { if($$3 == "\"$<\"") {x = 1; while(y < $$2) {print ""; y++} } else {x = 0} } x {x++} x > 2 {print; y++}' $@~ >$@ || $(clean)
	@ $(RM) $@~

%.moc: %.cc.moc.pre; moc $< -o $@ -i #$(tag)

%.moc.cc: %.moc.pre; moc $< -o $@ -f$(srcdir)/$* #$(tag)

%.moc.pre: CPPFLAGS += -MF /dev/null

## COMPILATION DES INTERFACES UI

all.ui = $(filter %.ui,$(all))
all.ui.h = $(addsuffix .h,$(all.ui))

$(all.o): | $(all.ui.h)

%.ui.h: %.ui | %/..; sed 's:\(<header>\):\1$(srcdir)/$(@D)/:' $< | uic -o $@ #$(tag)

## GÉNÉRATION DES RESSOURCES QRC

all.qrc = $(filter %.qrc,$(all))
all.qrc.o = $(addsuffix .o,$(all.qrc))

%.qrc: % | %/..; echo '<RCC version="1.0"><qresource><file alias="$*">$(realpath $<)</file></qresource></RCC>' >$@ #$(tag)

%.qrc.cc: %.qrc | %/..; rcc -o $@ $< -name $* #$(tag)

%.qrc.o: CPPFLAGS += -MF /dev/null
%.qrc.cc: CPPFLAGS += -MF $@.d

## MISE À JOUR DES CATALOGUES DE TRADUCTIONS

all.ts = $(filter %.ts,$(all))
all.ts.pre = $(addsuffix .ts.pre,$(all.cc))
all.qm = $(all.ts:ts=qm)

define each-ts

$(*:ts=qm.ts): $(addsuffix .$(*F),$(all.ts.pre) $(all.h) $(all.cc) $(all.ui))

%.$(*F): % $(srcdir)/$*
	cp $(srcdir)/$* $$@ #$$(tag)
	@ lupdate -silent -no-obsolete -locations absolute $$< -ts $$@
	@ sed -i '/filename=".*\.pre"/d; s:filename="\([^"]*\)":filename="$$(abspath $$(*D))/\1":' $$@

endef

$(foreach *,$(all.ts),$(eval $(each-ts)))

%.ts.pre: %.pre
	$(CPP) $(CPPFLAGS) -x c++ $< -o $@ -DQ_MOC_RUN -DQT_NO_TRANSLATION
	@ sed -i 's: $<\( \|$$\): :' $@.d

%.qm.ts: %.ts.date
	lconvert --sort-contexts --locations relative $(filter %.ts,$^) -o $> #$(tag)
	@ cp $> $@
	@ touch -d "$$(cat $*.ts.date)" $>

%.qm: %.qm.ts | %/..; lrelease -silent $< -qm $@ #$(tag)

%.qm.ts: > = $(srcdir)/$(@:qm.ts=ts)

.INTERMEDIATE: $(all.ts.pre)

endif
