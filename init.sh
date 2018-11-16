#!/bin/bash
if ! [ -x "$(command -v hexo)" ]; then
npm install -g hexo-cli
fi

if [ -d ./node_modules/ ]; then
    rm -rf ./node_modules/
fi

npm install
hexo clean