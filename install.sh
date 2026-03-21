#!/bin/bash

PACKAGES=(*/)
PACKAGES=("${@:-${PACKAGES[@]}}")

# Don't install .ignore/
shopt -u dotglob

cd $(dirname $0)

git stash &>/dev/null

# Add git config option without duplicate values
git-set-config() {
	local option=$1
	local value=$2
	git config set --global --value $value --all $option $value
}

if [[ "${PACKAGES[*]}" =~ "git" ]]; then
	git-set-config include.path .gitconfig-extra

	if command -v gh > /dev/null; then
		git-set-config include.path .gitconfig-credential
	fi
fi

stow -R --adopt --no-folding -v "${PACKAGES[@]}" 2>&1 | ./filter-stow-output.sh

# Restore changes from stow and any files ignored during installation
git restore .
git clean -fd .ignore

git stash pop &>/dev/null
