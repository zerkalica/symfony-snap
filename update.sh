#!/bin/sh

sdir=$(dirname $0)
[ -e $sdir/composer.json ] || sdir=$(pwd)
cdir="$(pwd)"
cd $sdir && sdir="$(pwd)"

git pull
$sdir/sbin/update.sh
cd "$cdir"
