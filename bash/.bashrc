#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -A'
alias lr='ls -R'
alias ll='ls -Alh'
alias grep='grep --color=auto'

alias vimsu='sudo -E vim'
alias adb-root='adb shell -t su - -c bash'

PS1='[\u@\h \W]\$ '

# Stop fastfetch from running in tmux panes
if [ -f /usr/bin/fastfetch ]; then
	if [[ -z $TERM_PROGRAM ]]; then
		fastfetch
	fi
fi
