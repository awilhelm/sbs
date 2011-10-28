#!/bin/sh

cd $(dirname $(readlink -f "$0"))

mkdir -p archive
ls -A | grep -Ev '^(archive|html|release|debug)$' | tar caf $(date +archive/%Y-%m-%d-%H.tar.xz) -T- --exclude '*~'

