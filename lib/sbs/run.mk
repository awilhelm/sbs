do.exec = $(cmd.$(cmd))
do.core = ulimit -c unlimited && $(cmd.$(cmd))
do.gdb = gdb -q -args $(cmd.$(cmd))
do.memcheck = valgrind --tool=memcheck --xml=yes --xml-file=memcheck.xml $(cmd.$(cmd))
do.callgrind = valgrind --tool=callgrind $(cmd.$(cmd))

arch.exec = release
arch.core = debug
arch.gdb = debug
arch.memcheck = debug
arch.callgrind = release

filter. = 2>&1 | c++filt | perl -pe '\
	s{(\s|^)($(objdir)|$(srcdir))/}{$$1}g;\
	s{(\s|^)$(prefix)/}{$$1/}g;\
	s{(\s|^)$(PWD)}{$$1.}g;\
	s{.*\(\[ "(.*?)" \]\).*}{[32m$$1};\
	s{$$}{[m};\
	s{^}{[31m} if m{\berror:}i;\
	s{^}{[33m} if m{\bwarning:}i;\
	s{^}{[34m} if m{\bnote:}i;\
	'

filter.exec = $(filter.)
filter.core = $(filter.)
filter.gdb =
filter.memcheck = $(filter.)
filter.callgrind = $(filter.)

cmd. = $(objdir)/*.elf $(args.$(args))
cmd.effibox = effibox --no-prompt --no-catch -a $(objdir)/*.so $(args.$(args))
