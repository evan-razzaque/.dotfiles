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

# Ubuntu being Ubuntu
unset command_not_found_handle

# Stop fastfetch from running in additional tmux panes and windows, as well as intergrated terminals (eg. vscode)
if command -v tmux > /dev/null 2>&1; then
    read TMUX_WINDOW_PANE_INDEX < <(tmux display-message -p "#{window_index},#{pane_index}")

    # Assumes base-index for windows and panes is 1; adjust if necessary
	if [ -z $TERM_PROGRAM -o "$TMUX_WINDOW_PANE_INDEX" == "1,1" ]; then
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
