#!/bin/bash

PACKAGES=(*/)
PACKAGES=("${@:-${PACKAGES[@]}}")

# Don't install .ignore/
shopt -u dotglob

cd $(dirname "$0")

stow -R --adopt --no-folding -nv "${PACKAGES[@]}" 2>&1 | ./filter-stow-output.sh
git clean -nd .ignore | sed 's|Would remove .ignore/|Ignoring |g'
