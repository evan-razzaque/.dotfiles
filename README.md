# Installation
**Warning:** Make sure to look through each dotfile and move the ones you don't want to .ignore/ before installation.
> If you have any staged files, they will be unstaged after installation.

1. Backup existing dotfiles for each package in this repository (.bashrc, .gitconfig, etc.)
2. Install ```stow``` from your package manager
3. *Optional*: Install ```nodejs``` (required for coc.nvim)
4. Run ```preview.sh``` to see which files will be created/overwritten
5. Run ```install.sh``` to create the symlinks for each package
