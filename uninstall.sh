#!/bin/bash

PACKAGES=(*/)
PACKAGES=("${@:-${PACKAGES[@]}}")

# Don't unlink .ignore/
shopt -u dotglob

cd $(dirname $0)

git stash &>/dev/null

# Remove git config option with a specific value
git-unset-config() {
	local option=$1
	local value=$2
	git config unset --global --value $value --all $option
}

if [[ "${PACKAGES[*]}" =~ "git" ]]; then
	git-unset-config include.path .gitconfig-extra
	git-unset-config include.path .gitconfig-credential
fi

stow -D --adopt --no-folding -v "${PACKAGES[@]}" 2>&1

# Restore changes from stow and any files ignored during uninstallation
git restore .
git clean -fd .ignore

git stash pop &>/dev/null
