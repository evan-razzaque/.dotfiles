#!/usr/bin/env bash

#
# ~/.bash_functions
#

mkcd() {
	mkdir -p $@
	cd ${@:$#}
}

# OSC 3008 escaping without external process. ~25x faster than sed equivalent.
__systemd_osc_context_escape() {
	local str="${1//\\/\\x5x}"
	echo "${str//;/\\x3b}"
}

# Shows the location of a function
wherefunc() (
	local func_name="$1"
	shopt -s extdebug
	declare -F "$func_name"
)

# Time a commnad with a desktop notification instead of outputting to stderr
time-notify() {
	[[ -f /usr/bin/time ]] || { /usr/bin/time; return $?; }

	local notify_time="${NOTIFY_TIME:-1500}"
	local tmp="$(mktemp)"

	/usr/bin/time -f %E -o $tmp $@
	local exit_code=$?

	local args="$@"
	notify-send -t 1500 -a time-cmd "$args" "Finished in $(tail -n1 $tmp)"
	rm $tmp

	return $exit_code
}

# Activate python venv for a tmux session
source-venv() {
	local venv="$1"
	[[ -z "$venv" ]] && { source; return $?; }

	export() {
		# Don't export empty variables
		[[ -z "${!1}" ]] && return

		builtin export "$@"
		if [[ -n "$TMUX" ]]; then
			tmux setenv "$1" "${!1}"
		fi
	}

	unset() {
		builtin unset "$@"
		if [[ -n "$TMUX" ]]; then
			local args="$@"
			tmux setenv -u "${args//@(-f|-v|-n)/}"
		fi
	}

	if source "$venv"/bin/activate; then
		tmux set @venv-deactivate "$(declare -f deactivate)"
	fi

	export _OLD_VIRTUAL_PATH
	export _OLD_VIRTUAL_PYTHONHOME
	export _OLD_VIRTUAL_PS1

	builtin unset -f export unset
}

# Deactivate python venv for a tmux session
deactivate-venv() {
	export() {
		builtin export "$@"
		if [[ -n "$TMUX" ]]; then
			tmux setenv "$1" "${!1}"
		fi
	}

	unset() {
		builtin unset "$@"
		if [[ -n "$TMUX" ]]; then
			local args="$@"
			tmux setenv -u "${args//@(-f|-v|-n)/}"
		fi
	}

	eval "$(tmux show -v @venv-deactivate)"
	deactivate

	tmux set -u @venv-deactivate

	builtin unset -f export unset
}
