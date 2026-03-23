#!/bin/bash

PACKAGES=(*/)
PACKAGES=("${@:-${PACKAGES[@]}}")

# Don't unlink .ignore/
shopt -u dotglob

cd $(dirname $0)

./stow-cmd.sh -Dn "${PACKAGES[@]}"
git clean -nd .ignore | sed 's|Would remove .ignore/|Not removing |g'
