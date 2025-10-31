#!/bin/bash

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi

stow --adopt -nv */ 2>&1 | grep -vP '^MV'
git clean -nd .ignore
