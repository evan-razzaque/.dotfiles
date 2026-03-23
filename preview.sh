#!/bin/bash

PACKAGES=(*/)
PACKAGES=("${@:-${PACKAGES[@]}}")

# Don't install .ignore/
shopt -u dotglob

cd $(dirname "$0")

./stow-cmd.sh -Rn "${PACKAGES[@]}"
git clean -nd .ignore | sed 's|Would remove .ignore/|Ignoring |g'
