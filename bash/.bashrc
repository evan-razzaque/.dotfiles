#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color'

alias la='ls -A'
alias lr='ls -R'
alias ll='ls -Alh'

alias clipboard='xsel -b'
alias du='du --exclude /proc'
alias open='xdg-open'

alias compiledb='compiledb --command-style'

alias tmux-new='tmux new -s "#{server_sessions}"'

# Ubuntu being Ubuntu
unset command_not_found_handle

# Some systems alias which (who knows why, just use type)
unalias which 2> /dev/null

# Stop fastfetch from running multiple times in a tmux session, as well as intergrated terminals (eg. vscode)
if command -v fastfetch > /dev/null 2>&1; then
    read TMUX_WINDOW_COUNT < <(tmux list-windows 2> /dev/null | wc -l)
    read TMUX_PANE_COUNT < <(tmux list-panes 2> /dev/null | wc -l)

    # Assumes base-index for windows and panes is 1; adjust if necessary
    if [[ -z $TERM_PROGRAM \
        || "$TMUX_WINDOW_COUNT" == "1" && "$TMUX_PANE_COUNT" == "1" ]]; then
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
