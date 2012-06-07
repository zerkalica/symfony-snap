#!/bin/sh

sdir=$(dirname $0)
[ -e $sdir/composer.json ] || sdir=$(pwd)
sdir=$(realpath "$sdir")

cd $sdir && git pull

$sdir/sbin/update.sh
