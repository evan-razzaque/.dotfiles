#!/bin/bash

cd $(dirname "$0")

declare -a PACKAGES
source stow-cmd.sh "$@"

stow-cmd-preview -R
git clean -nd .ignore | sed 's|Would remove .ignore/|Ignoring |g'
