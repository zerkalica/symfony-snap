#!/bin/sh

sdir=$(dirname $0)/..
[ -e $sdir/composer.json ] || sdir=$(pwd)/..
cdir="$(pwd)"
cd $sdir && sdir="$(pwd)"

prod_sdir="$(dirname $sdir)/boombate-snap-prod"

[ -d "$prod_sdir" ] || git clone git@github.com:boombate/boombate-snap.git "$prod_sdir"

rm -rf "$prod_sdir/vendor"
rm -rf "$prod_sdir/bin"
rm -rf "$prod_sdir/sbin"

cd $prod_sdir ; git pull

cp -Ra $sdir/* $prod_sdir/

echo "Removing .git directory"
cd $prod_sdir/vendor && find . -type d -name '.git' -exec rm -rf {} \; 2> /dev/null
echo "Fixing line ends"
#cd $prod_sdir && find . -type f -regex '.*\.\(sh\|php\|md\|txt\|md\|js\|css\|html\|res\|twig\|json\|xml\|yml\|dist\|rst\|bat\|xsl\|ini\|inc\|bat\|cmd\|java\|uxf\)' -exec sed 's/\r//g' -i {} \;
#cd $prod_sdir && find . -type f -regex '.*\(LICENSE\|README\)' -exec sed 's/\r//g' -i {} \;
cd $prod_sdir && \
    git config core.autocrlf true && git config core.eol lf && git config core.safecrlf false && \
    git pull origin master && \
    git add . && \
    git commit -am "updating snap" && \
    git push

cd "$cdir"
