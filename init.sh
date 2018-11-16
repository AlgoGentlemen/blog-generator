#!/bin/bash
if [ -d ./public/ ]; then
    rm -rf ./public/
fi
if [ -d ./node_modules/ ]; then
    rm -rf ./node_modules/
fi
if [ -d ./.deploy_git/ ]; then
    rm -rf ./.deploy_git/
fi
npm install