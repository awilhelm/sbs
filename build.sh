#!/bin/sh

reset
ulimit -c unlimited

build() {
	cd $(dirname $(readlink -f "$0"))
	make -j $(grep -c processor /proc/cpuinfo) "$@"
}

while test "$#" -gt 0
do case "$1" in
	-i) interactive=true; shift;;
	gdb) interactive=true; break;;
	*) break;;
esac
done

if test "$interactive"
then build "$@"
else build "$@" 2>&1 | c++filt | ./build.pl
fi

