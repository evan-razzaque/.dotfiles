#
# ~/.bashrc
#
# shellcheck disable=SC1091,SC1090
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1_STRING='[\u@\h \W]\$ '
if [[ -e "$SSH_TTY" ]]; then
	PS1_STRING="(ssh) $PS1_STRING"
fi

# Retain python venv prompt
if [[ ! "$PS1" =~ "$PS1_STRING" ]]; then
	PS1="$PS1_STRING"
fi

unset PS1_STRING

INPUTRC=~/.config/readline/inputrc

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
	if [[ -n "$TMUX" ]] && command -v tmux > /dev/null; then
		TMUX_WINDOW_COUNT=$(tmux list-windows 2> /dev/null | wc -l)
		TMUX_PANE_COUNT=$(tmux list-panes 2> /dev/null | wc -l)
	fi

	if [[ -z "$TERMINAL_EMULATOR" ]] && [[ -z "$TERM_PROGRAM" \
		|| "$TMUX_WINDOW_COUNT" == "1" && "$TMUX_PANE_COUNT" == "1" ]]; then
		fastfetch
	fi
fi

unset FASTFETCH TMUX_PANE_COUNT TMUX_WINDOW_COUNT

source-config-files() {
	# shellcheck disable=SC2155
	local bash_config="$HOME/.config/bash"
	local -a rc_files

	rc_files=("$bash_config/rc.d/"*.sh)
	rc_files+=("$bash_config/rc.d/"*.bash)

	source "$bash_config/aliases"
	source "$bash_config/functions"

	local file
	for file in "${rc_files[@]}"; do
		[[ -r "$file" ]] && source "$file"
	done
} && source-config-files

unset -f source-config-files
