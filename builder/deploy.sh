#!/bin/bash

git pull
hugo
cp -r ./public/* ../
cd ..
git add --all
git commit -m "$1"
gpg -d ~/keys/gitAccessToken.txt.gpg
git push

