#
# ~/.bash_profile
#

export PATH="$PATH:~/.bin:~/.local/bin"
export MAKEFLAGS="--jobs=$(nproc) --output-sync"
export EDITOR=vim

[[ -f ~/.bashrc ]] && . ~/.bashrc

