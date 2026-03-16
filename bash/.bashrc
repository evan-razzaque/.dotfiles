#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1_STRING='[\u@\h \W]\$ '

# Retain python venv prompt
if [[ ! "$PS1" =~ "$PS1_STRING" ]]; then
	PS1="$PS1_STRING"
fi

# Ubuntu being Ubuntu
unset command_not_found_handle

# Some systems alias which (who knows why, just use type)
unalias which 2> /dev/null

# Stop fastfetch from running multiple times in a tmux session, as well as intergrated terminals (eg. vscode)
# Also allows for fastfetch to be turned off by setting FASTFETCH=0 and/or FASTFETCH_DISABLE=0
if command -v fastfetch > /dev/null && \
	[ "$FASTFETCH" != 0 ] && \
	[ "$FASTFETCH_DISABLE" != 0 ]
then
	if command -v tmux > /dev/null; then
		read TMUX_WINDOW_COUNT < <(tmux list-windows 2> /dev/null | wc -l)
		read TMUX_PANE_COUNT < <(tmux list-panes 2> /dev/null | wc -l)
	fi

	if [[ -z "$TERMINAL_EMULATOR" ]] && [[ -z "$TERM_PROGRAM" \
		|| "$TMUX_WINDOW_COUNT" == "1" && "$TMUX_PANE_COUNT" == "1" ]]; then
		fastfetch
	fi
fi

unset FASTFETCH

source() {
	local file="$1"

	[[ -f "$file" ]] && builtin source "$file"
}

# Aliases
source ~/.bash_aliases

# Shell functions
source ~/.bash_functions

# User-defined config
source ~/.bashrc_user

unset -f source
