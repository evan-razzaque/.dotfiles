# Installation
**Warning:** Make sure to look through each package/file and add the ones
you don't want to ./.stow-global-ignore (or ~/.stow-global-ignore) before installation.
<br>[Stow ignore syntax](https://www.gnu.org/software/stow/manual/stow.html#Types-And-Syntax-Of-Ignore-Lists)

Required packages:
- stow
- wget (for vim-plug)

Optional packages:
- nodejs (required by coc.nvim)
- github-cli (required for git credential helper)
- clang (for coc-clangd)
- the_silver_searcher (for fzf in vim)

1. Backup existing dotfiles for each package in this repository (.bashrc, .bash_profile, etc.)
2. Run ```preview``` to see which files will be created/overwritten
3. Run ```install``` to create the symlinks for each package

# Uninstallation
Similar to installation, any package/file you don't want to unlink can be
added to .stow-global-ignore.

1. Run ```uninstall-preview``` to see which symlinks will be removed
2. Run ```uninstall``` to remove the symlinks for each package
