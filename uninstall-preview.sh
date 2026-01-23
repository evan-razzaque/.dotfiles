#!/bin/bash

# Don't unlink .ignore/
shopt -u dotglob

cd $(dirname $0)

stow -D --no-folding -nv */ 2>&1 | ./filter-stow-output.sh
git clean -nd .ignore | sed 's|Would remove .ignore/|Not removing |g'
