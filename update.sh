#!/bin/sh

sdir=$(dirname $0)
[ -e $sdir/composer.json ] || sdir=$(pwd)
sbin=$(realpath $sbin)

cd $sdir && git pull

$sdir/sbin/update.sh
