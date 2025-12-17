#!/bin/bash

stow --adopt --no-folding -nv */ 2>&1 | grep -vP '^MV'
git clean -nd .ignore
