#!/bin/bash

git config --global include.path .gitconfig-extra

git add -A
stow --adopt --no-folding -v */ 2>&1 | grep -vP '^MV'

# Restore changes from stow
git restore .

# Restore working tree prior to installation
git restore --staged .
mv .ignore/* -t .
mv README.txt .ignore
