# Installation
**Warning:** Make sure to look through each package/file and move the ones you don't want to .ignore/ before installation.

Required packages:
- stow

Optional packages:
- nodejs (required by coc.nvim)
- github-cli (required for git credential helper)

1. Backup existing dotfiles for each package in this repository (.bashrc, .bash_profile, etc.)
2. Run ```preview.sh``` to see which files will be created/overwritten
3. Run ```install.sh``` to create the symlinks for each package

# Uninstallation

1. Move any packages/files you don't want to unlink to .ignore/
2. Run ```uninstall-preview.sh``` to see which symlinks will be removed
3. Run ```uninstall.sh``` to remove the symlinks for each package
