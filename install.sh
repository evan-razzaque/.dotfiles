#!/bin/bash

cd $(dirname $0)

declare -a PACKAGES
source stow-cmd.sh "$@"

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

stow-cmd -R
