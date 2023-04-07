#!/bin/sh

REPO_URL=git@127.0.0.1:user/test.git
FILE=TODO

function init_repository() {
	git init
	git add $FILE
	git commit -m 'initial commit'
	git branch -M master
	git remote add origin $REPO_URL
	git push -u origin master
}

init_repository
