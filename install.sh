#!/bin/bash

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi

stow --adopt -v */
git restore .
git clean -fd
