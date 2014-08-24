#!/bin/sh

if [ $# -eq 0 ]; then
    echo "No arguments supplied";
    exit 1
fi

if [ -d "repos/$1" ]; then
    rm -rf "repos/$1"
fi

mkdir -p "repos/$1"
cd $_
pwd

echo "$ git clone https://github.com/$1.git ."
git clone "https://github.com/$1.git" . &> /dev/null

echo "$ npm install"
npm install --no-color > /dev/null

if [ ! -e "npm-shrinkwrap.json" ]; then
    echo "$ npm shrinkwrap --dev"
    npm shrinkwrap --dev
fi

echo "$ # sudo npm i nsp -g"
echo "$ nsp audit-shrinkwrap"
nsp audit-shrinkwrap || true

echo "$ npm outdated --depth 0"
npm outdated --depth 0 | sort

if [ -e ".travis.yml" ]; then
    echo "$ travis-lint # http://lint.travis-ci.org/$1"
    travis-lint
else
    echo "# .travis.yml not found"
fi
