
all.h = $(shell find $(VPATH) -name '*.h')

all.c = $(shell find $(VPATH) -name '*.c')

all.cc = $(shell find $(VPATH) -name '*.cc')

all.f = $(shell find $(VPATH) -name '*.f')

all.s = $(shell find $(VPATH) -name '*.s')

all.o = $(patsubst $(VPATH)%,%.o,$(basename $(all.c) $(all.cc) $(all.f) $(all.s)))

all.moc.o = $(patsubst $(VPATH)%,%.moc.o,$(all.h))

all.qrc = $(shell find $(VPATH) -name '*.qrc')

all.qrc.o = $(patsubst $(VPATH)%,%.o,$(all.qrc))

all.ui = $(shell find $(VPATH) -name '*.ui')

all.ui.h = $(patsubst $(VPATH)%,%.h,$(all.ui))

rules.moc = $(foreach *,$(all.cc),$(eval $(patsubst $(VPATH)%.cc,%.o,$*): $(patsubst $(VPATH)%.cc,%.moc,$*)))

rules.ui = $(eval $(patsubst $(VPATH)%,%,$(all.cc)): $(all.ui.h))

rules.qrc = $(foreach *,$(all.qrc),$(eval $(patsubst $(VPATH)%,%.cc,$*): $(addprefix $(dir $(patsubst $(VPATH)%,%,$*)),$(shell perl -e '$$/ = undef; $$_ = <>; s/^.*?<file.*?>(.*)<\/file>.*$$/$$1/s; s/<\/file>.*?<file.*?>/\n/gs; print' $*))))

