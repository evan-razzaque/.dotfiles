#!/bin/bash

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi

stow --adopt -nv */
