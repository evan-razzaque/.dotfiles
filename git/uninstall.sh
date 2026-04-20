#!/bin/bash

# Remove git config option with a specific value
git-unset-config() {
	local option=$1
	local value=$2
	git config unset --global --value "$value" --all "$option"
}

GIT_CONFIG_DIR=~/.config/git

git-unset-config include.path "$GIT_CONFIG_DIR/.gitconfig-extra"
git-unset-config include.path "$GIT_CONFIG_DIR/.gitconfig-credential"
