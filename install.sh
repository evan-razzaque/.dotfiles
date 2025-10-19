#!/bin/bash

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi

stow --adopt -v */ 2>&1 | grep -vP '^MV'
git restore .
git clean -fd
