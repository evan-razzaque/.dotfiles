#!/bin/bash

cd $(dirname $0)

# Remove git config option with a specific value
git-unset-config() {
	local option=$1
	local value=$2
	git config unset --global --value $value --all $option $value
}

git-unset-config include.path .gitconfig-extra
git-unset-config include.path .gitconfig-credential

stow -D --adopt --no-folding -v */ 2>&1

# Restore changes from stow and any files ignored during uninstallation
git restore .

git clean -fd .ignore
