#!/bin/bash
if [ -d ./node_modules/ ]; then
    rm -rf ./node_modules/
fi
npm install
hexo clean