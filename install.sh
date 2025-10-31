#!/bin/bash

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi

git add -A
stow --adopt -v */ 2>&1 | grep -vP '^MV'

# Restore changes from stow
git restore .

# Restore working tree prior to installation
git restore --staged .
mv .ignore/* -t .
mv README.txt .ignore
