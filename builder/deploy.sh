#!/bin/bash

hugo
cp -r ./public/* ../
cd ..
git add --all
git commit -m '$1'
cat ~/pems/gitAccessToken.txt
git push

