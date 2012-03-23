
all.moc.o = $(patsubst $(VPATH)%,%.moc.o,$(all.h))

all.qrc = $(shell find $(VPATH) -name '*.qrc')

all.qrc.o = $(patsubst $(VPATH)%,%.o,$(all.qrc))

all.ui = $(shell find $(VPATH) -name '*.ui')

all.ui.h = $(patsubst $(VPATH)%,%.h,$(all.ui))

rules.moc = $(foreach *,$(all.cc),$(eval $(patsubst $(VPATH)%.cc,%.o,$*): $(patsubst $(VPATH)%.cc,%.moc,$*)))

rules.ui = $(eval $(patsubst $(VPATH)%,%,$(all.cc)): $(all.ui.h))

rules.qrc = $(foreach *,$(all.qrc),$(eval $(patsubst $(VPATH)%,%.cc,$*): $(addprefix $(dir $(patsubst $(VPATH)%,%,$*)),$(shell perl -e '$$/ = undef; $$_ = <>; s/^.*?<file.*?>(.*)<\/file>.*$$/$$1/s; s/<\/file>.*?<file.*?>/\n/gs; print' $*))))

%.moc.cc: %; moc -o $@ $<

%.moc: %.cc; moc -o $@ $<

%.ui.h: %.ui; sed "s:\(<header>\):\1$(VPATH)$(@D)/:" $< | uic -o $@

%.qrc.cc: %.qrc
	@$(foreach file,$(filter $(VPATH)%,$^),ln -fs $(file) $(patsubst $(VPATH)%,%,$(file));)
	rcc -o $@ $*.qrc -name $*

%.qm: %.ts; lrelease -qm $@ $< -silent

%.qrc:;

.PRECIOUS: %.moc.cc %.moc.h %.ui.h %.qrc.cc %.qm

CPPFLAGS +=\
	-isystem/usr/include/qt4\
	-isystem/usr/include/qt4/QtCore\
	-isystem/usr/include/qt4/QtGui\
	-isystem/usr/include/qt4/QtScript\
	-isystem/usr/include/qt4/QtXml\
	-DQT_NO_KEYWORDS\

LDLIBS +=\
	-lQtCore\
	-lQtGui\
	-lQtScript\
	-lQtXml\

