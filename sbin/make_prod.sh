#!/bin/sh

sdir=$(dirname $0)/..
[ -e $sdir/composer.json ] || sdir=$(pwd)/..
sdir=$(realpath "$sdir")

prod_sdir="$(dirname $sdir)/boombate-snap-prod"

[ -d "$prod_sdir" ] || git clone git@github.com:boombate/boombate-snap.git "$prod_sdir"

rm -rf "$prod_sdir/vendor"
rm -rf "$prod_sdir/bin"
rm -rf "$prod_sdir/sbin"
cp -Ra $sdir/* $prod_sdir/

echo "Removing .git directory"
cd $prod_sdir/vendor && find . -type d -name '.git' -exec rm -rf {} \; 2> /dev/null
echo "Fixing line ends"
cd $prod_sdir && find . -type f -regex '.*\.\(sh\|php\|md\|txt\|md\|html\|res\|twig\|json\|xml\|yml\|dist\|rst\|bat\)' -exec sed 's/\r//g' -i {} \;
cd $prod_sdir && find . -type f -regex 'LICENSE|README' -exec sed 's/\r//g' -i {} \;

cd "$prod_sdir" && git add . && git commit -am "updating snap" && git push

