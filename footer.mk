
%.so:; $(LINK.o) $(LDLIBS) -shared -fpic -o $@ $^

%.a:; $(AR) rcs $@ $^

%.moc.cc: %; moc -o $@ $<

%.moc: %.cc; moc -o $@ $<

%.ui.h: %.ui; sed "s:\(<header>\):\1$(VPATH)$(@D)/:" $< | uic -o $@

%.qrc.cc: %.qrc
	@$(foreach file,$(filter $(VPATH)%,$^),ln -fs $(file) $(patsubst $(VPATH)%,%,$(file));)
	rcc -o $@ $*.qrc -name $*

%.qm: %.ts; lrelease -qm $@ $< -silent

%.qrc:;

.DELETE_ON_ERROR:

.PRECIOUS: %.moc.cc %.moc.h %.ui.h %.qrc.cc %.qm

include $(shell find -name '*.d')

