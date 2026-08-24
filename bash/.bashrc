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

# Readline
HISTIGNORE+="&:?:??:poweroff:shutdown:reboot:systemctl suspend:systemctl soft-reboot"
INPUTRC=~/.config/readline/inputrc

# Ubuntu being Ubuntu
unset command_not_found_handle

# Some systems alias which (who knows why, just use type)
unalias which 2> /dev/null

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
