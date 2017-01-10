#!/bin/bash

git pull
hugo
cp -r ./public/* ../
cd ..
git add --all
git commit -m "$1"
gpg -d ~/pems/gitAccessToken.txt.gpg
git push

