#!/bin/bash
NAME=$1
REPOSITORY=$2
FERNET_VERSION=$3

cd ~/projects
echo "create fernet project"
composer create-project fernet/fernet --remove-vcs -n -q $NAME $FERNET_VERSION
cd $NAME
echo "installing npm"
npm install --no-audit --no-fund
echo "create git"
git init
echo "add remotes"
git remote add origin $REPOSITORY 
git remote add prod ec2-user@albo.cc:/repository/$NAME.git
echo "change readme"
echo "# $NAME" > README.md
echo "initial import"
git add .
git commit -m "initial import"
echo "rename branch"
git branch -M main
$SHELL
