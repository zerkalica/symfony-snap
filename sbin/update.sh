#!/bin/sh

sdir=$(dirname $0)/..
[ -e $sdir/composer.json ] || sdir=$(pwd)/..
cdir="$(pwd)"
cd $sdir && sdir="$(pwd)"

CSSEMBED_VERSION="0.4.5"
YUICOMPRESSOR_VERSION="2.4.7"
SELENIUM_VERSION="2.25.0"
ANT_VERSION="1.8.4"

_exit() {
    echo "$@"
    exit 1
}

check() {
    [ "$(which wget)" ] || _exit "wget not found"
    [ -d "$sdir/bin" ] || mkdir -p "$sdir/bin"
}

install() {
    cd $sdir
    [ -e "$sdir/sbin/composer.phar" ] || wget -c "http://getcomposer.org/composer.phar" -O "$sdir/sbin/composer.phar"
}

download_selenium() {
    [ -e "$sdir/bin/selenium-server.jar" ] || wget -c "http://selenium.googlecode.com/files/selenium-server-standalone-$SELENIUM_VERSION.jar" -O "$sdir/bin/selenium-server.jar"
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

update_fix() {
    cd $sdir/vendor/twitter/bootstrap && git checkout 2.1.0-wip && git pull
    find $sdir/vendor -type d -name '.git' | \
    while read d ; do
        echo $(basename $(dirname $d))
        cd $d/..
        git reset --hard
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

phpunit_fix() {
    cd $sdir/bin
    for i in ../vendor/zerkalica/phpunit/bin/* ; do
        [ "$(basename $i)" = "init.php" ] && continue
        [ -L "$(basename $i)" ] || ln $i $(basename $i)
    done
}

check
install

download_cssembed
download_yui
download_selenium

update_vendors

update_fix
update_bs

phpunit_fix

cd "$cdir"
