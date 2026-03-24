#!/bin/bash

cd $(dirname $0)

declare -a PACKAGES
source stow-cmd.sh "$@"

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

stow-cmd -D
