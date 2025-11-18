#
# ~/.bash_profile
#

export PATH="$PATH:~/.bin:~/.local/bin"
export MAKEFLAGS="--jobs=$(nproc) --output-sync"

export EDITOR=vim
export TIME_STYLE=long-iso

[[ -f ~/.bashrc ]] && . ~/.bashrc

