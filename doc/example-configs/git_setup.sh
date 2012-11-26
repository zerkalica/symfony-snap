#!/bin/sh
name=$1
email="$2"

git config --global core.autocrlf true && git config --global core.eol lf && git config --global core.safecrlf false
git config --global user.name "$name" git config --global user.email "$email"
git config --global rebase.autosquash true
#git config --global pull.octopus
git config --global push.default current
