#!/bin/sh

cd $(dirname $(readlink -f "$0"))

make -j $(grep -c processor /proc/cpuinfo) "$@" 2>&1 | c++filt | ./build.pl

