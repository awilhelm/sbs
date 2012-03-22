#!/bin/sh

export cwd=$(dirname $(readlink -f "$0"))

reset
ulimit -c unlimited

build() {
	make -j $(grep -c processor /proc/cpuinfo) -f "$cwd/makefile" "$@"
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
else build "$@" 2>&1 | c++filt | "$cwd/build.pl"
fi

