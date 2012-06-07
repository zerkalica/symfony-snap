#!/bin/sh

sdir=$(dirname $0)

[ -x $sdir/composer.json ] || sdir=$(pwd)

cd $sdir && git pull

$sdir/sbin/update.sh
