#!/bin/sh

sdir=$(dirname $0)

[ -x $sdir/composer.json ] || sdir=$(pwd)

sdir=$(dirname $sdir)

CSSEMBED_VERSION="0.4.5"
YUICOMPRESSOR_VERSION="2.4.7"

_exit() {
    echo "$@"
    exit 1
}

check() {
    [ "$(which npm)" ] || _exit "npm not found"
    [ "$(which wget)" ] || _exit "wget not found"
    [ -d "$sdir/bin" ] || mkdir -p "$sdir/bin"
}

install() {
    cd $sdir
    [ -e "$sdir/sbin/composer.phar" ] || wget -c "http://getcomposer.org/composer.phar" -O "$sdir/sbin/composer.phar"
    [ -d "$sdir/node_modules/less" ] || npm install less
}


download_cssembed() {
    [ -e "$sdir/bin/cssembed.jar" ] || wget -c "https://github.com/downloads/nzakas/cssembed/cssembed-$CSSEMBED_VERSION.jar" -O "$sdir/bin/cssembed.jar"
}

download_yui() {
    if [ ! -e "$sdir/bin/yuicompressor.jar" ] ; then
        wget -c "http://pypi.python.org/packages/source/y/yuicompressor/yuicompressor-$YUICOMPRESSOR_VERSION.tar.gz" -O "$sdir/bin/yuicompressor.tar.gz"
        cd "$sdir/bin"
        tar xfz "$sdir/bin/yuicompressor.tar.gz"
        cp "$sdir/bin/yuicompressor-$YUICOMPRESSOR_VERSION/yuicompressor/yuicompressor.jar" "$sdir/bin/yuicompressor.jar"
        rm -rf "$sdir/bin/yuicompressor-$YUICOMPRESSOR_VERSION"
        rm "$sdir/bin/yuicompressor.tar.gz"
    fi
}

update_npm() {
    cd $sdir && npm update
    cd $sdir && $sdir/sbin/composer.phar self-update
}

update_fix() {
    cd $sdir/vendor/twitter/bootstrap && git checkout 2.1.0-wip && git pull
    find $sdir/vendor -type d -name '.git' | \
    while read d ; do
        echo $(basename $(dirname $d))
        cd $d/..

        git checkout master 2> /dev/null 1> /dev/null ; git pull
    done
}

update_bs() {
    local bdir="$sdir/vendor/zerkalica/millwright-twitter-bootstrap-bundle/Millwright/TwitterBootstrapBundle/Resources/public/bootstrap"
    rm -rf "$bdir"
    cp -Ra $sdir/vendor/twitter/bootstrap $bdir
    cd $bdir && rm * .* 2> /dev/null
    cd $bdir && rm -rf .git docs js/tests less/tests
    cd $bdir && git checkout master && git add . && git commit -am "updated bootstrap" && git fetch && git rebase origin/master && git push
}

update_vendors() {
    cd $sdir && php $sdir/sbin/composer.phar update
}

check
install
update_npm

download_cssembed
download_yui

update_vendors
update_fix
update_bs
