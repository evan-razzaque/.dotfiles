#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias ls='ls --color=auto'
alias la='ls -A'
alias lr='ls -R'
alias ll='ls -Alh'
alias grep='grep --color=auto'

alias clipboard='xsel -b'
alias du='du --exclude /proc'
alias open='xdg-open'

# Ubuntu being Ubuntu
unset command_not_found_handle

# Stop fastfetch from running in tmux panes
if [ -f /usr/bin/fastfetch ]; then
	if [ -z $TERM_PROGRAM ]; then
		fastfetch
	fi
fi

# User-defined aliases
if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

# Shell functions
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

export EDITOR=vim
