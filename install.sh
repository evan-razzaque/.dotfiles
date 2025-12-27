#!/bin/bash

cd $(dirname $0)

# Add git config option without duplicate values
git-set-config() {
	local option=$1
	local value=$2
	git config set --global --value $value --all $option $value
}

git-set-config include.path .gitconfig-extra

# Check if user has github-cli for git credential helper
if command -v gh > /dev/null; then
	git-set-config include.path .gitconfig-credential
fi

git add -A
stow -R --adopt --no-folding -v */ 2>&1 | ./filter-stow-output.sh

# Restore changes from stow
git restore .

# Restore working tree prior to installation
git restore --staged .
mv .ignore/* -t .
mv README.txt .ignore
