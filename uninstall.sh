#!/bin/bash

cd $(dirname $0)

declare -a PACKAGES
source stow-cmd.sh "$@"

for package in "${PACKAGES[@]}"; do
	SCRIPT="$package/uninstall.sh"
	[[ -f $SCRIPT ]] || continue
	"./$SCRIPT"
done

stow-cmd -D
