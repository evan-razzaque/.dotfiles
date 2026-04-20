#!/bin/bash

cd $(dirname $0)

declare -a PACKAGES
source stow-cmd.sh "$@"

stow-cmd -R

for package in "${PACKAGES[@]}"; do
	SCRIPT="$package/install.sh"
	[[ -f $SCRIPT ]] || continue
	"./$SCRIPT"
done
