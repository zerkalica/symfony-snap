#!/bin/sh

NPM_PACKAGES="$HOME/.npm-packages"
mkdir -p "$NPM_PACKAGES"
echo "prefix = $NPM_PACKAGES" > ~/.npmrc
cp .profile $HOME/

export NPM_PACKAGES

npm install -g

#mkdir -p "web"
#cd web
#bbb init
