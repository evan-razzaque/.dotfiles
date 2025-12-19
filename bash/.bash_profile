#
# ~/.bash_profile
#

export PATH="$PATH:~/.bin:~/.local/bin"
export MAKEFLAGS="--jobs=$(nproc) --output-sync"

export EDITOR=vim
export TIME_STYLE=long-iso

export PYTHONPATH=$PYTHONPATH:$(find /usr/local/lib -name "site-packages" 2> /dev/null)

[[ -f ~/.bashrc ]] && . ~/.bashrc

