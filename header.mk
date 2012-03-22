
all.h = $(shell find $(VPATH) -name '*.h' -o -name '*.hh' -o -name '*.hpp')

all.c = $(shell find $(VPATH) -name '*.c')

all.cc = $(shell find $(VPATH) -name '*.cc' -o -name '*.C' -o -name '*.cpp')

all.f = $(shell find $(VPATH) -iname '*.f')

all.s = $(shell find $(VPATH) -iname '*.s')

all.o = $(patsubst $(VPATH)%,%.o,$(basename $(all.c) $(all.cc) $(all.f) $(all.s)))

all.moc.o = $(patsubst $(VPATH)%,%.moc.o,$(all.h))

all.qrc = $(shell find $(VPATH) -name '*.qrc')

all.qrc.o = $(patsubst $(VPATH)%,%.o,$(all.qrc))

all.ui = $(shell find $(VPATH) -name '*.ui')

all.ui.h = $(patsubst $(VPATH)%,%.h,$(all.ui))

rules.moc = $(foreach *,$(all.cc),$(eval $(patsubst $(VPATH)%.cc,%.o,$*): $(patsubst $(VPATH)%.cc,%.moc,$*)))

rules.ui = $(eval $(patsubst $(VPATH)%,%,$(all.cc)): $(all.ui.h))

rules.qrc = $(foreach *,$(all.qrc),$(eval $(patsubst $(VPATH)%,%.cc,$*): $(addprefix $(dir $(patsubst $(VPATH)%,%,$*)),$(shell perl -e '$$/ = undef; $$_ = <>; s/^.*?<file.*?>(.*)<\/file>.*$$/$$1/s; s/<\/file>.*?<file.*?>/\n/gs; print' $*))))

install = $(foreach 3,$1,$(foreach 4,$(patsubst %,$(DESTDIR)/$2,$(patsubst $(VPATH)%,%,$3)),$(eval all: $4)$(eval $4: $3)))

