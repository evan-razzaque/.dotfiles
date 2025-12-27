#!/bin/bash

cd $(dirname $0)

stow -R --adopt --no-folding -nv */ 2>&1 | ./filter-stow-output.sh
git clean -nd .ignore
