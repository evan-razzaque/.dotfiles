#!/bin/bash

# Add git config option without duplicate values
git-set-config() {
	local option=$1
	local value=$2
	git config set --global --value "$value" --all "$option" "$value"
}

GIT_CONFIG_DIR=~/.config/git

git-set-config include.path "$GIT_CONFIG_DIR/.gitconfig-extra"

if command -v gh > /dev/null; then
	git-set-config include.path "$GIT_CONFIG_DIR/.gitconfig-credential"
fi
