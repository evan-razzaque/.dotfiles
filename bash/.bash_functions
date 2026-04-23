#!/usr/bin/env bash
#
# ~/.bash_functions
#
# Source (the command) warnings
# shellcheck disable=SC1090,SC1091

mkcd() {
	if [[ $# -gt 1 ]]; then
		echo "${FUNCNAME[0]}: too many arguments" >&2
		return 1
	fi

	mkdir -p "$1" || return $?
	cd "$1" || return $?
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

# Rename a function
renamefunc() {
	local current_name="$1"
	local new_name=$2

	local new_name_sanitized="${new_name//[^[:alnum:]-_]/}"

	if [[ "$new_name" != "$new_name_sanitized" ]]; then
		echo "$0: '$new_name' is not a valid function name"
		return 1
	fi

	if ! command -v "$current_name" &>/dev/null; then
		"$current_name"
		return 2
	fi

	[[ -z "$new_name" ]] && return 1

	eval "$new_name() $(declare -f "$current_name" | tail -n +2)"
	unset -f "$current_name"
}

# Time a commnad with a desktop notification instead of outputting to stderr
time-notify() {
	if [[ ! -f /usr/bin/time ]]; then
		/usr/bin/time
		return $?
	fi

	local tmp notify_time
	tmp="$(mktemp)" || return $?
	notify_time="${NOTIFY_TIME:-1500}"

	/usr/bin/time -f %E -o "$tmp" "$@"
	local exit_code=$?

	local args="$*"
	notify-send -t "$notify_time" -a "${FUNCNAME[0]}" "$args" "Finished in $(tail -n1 "$tmp")"
	rm "$tmp"

	return $exit_code
}

# Export and unset environment variables for tmux
_tmux_export_unset() {
	if [[ -z "${FUNCNAME[1]}" ]]; then
		echo "Cannot be called outside of a function" >&2
		return 1
	fi

	export() {
		builtin export "${@?}" || return
		local tmux_cmd="tmux"
		[[ -z "$TMUX" ]] && tmux_cmd=:

		for arg in "$@"; do
			[[ "$arg" =~ "-" ]]	&& continue

			value=${arg#*=}
			name=${arg%"=$value"}
			[[ "$value" == "$arg" ]] && value=${!name}

			if [[ -z "$value" ]]; then
				builtin unset "$name"
				continue
			fi

			$tmux_cmd setenv "$name" "$value"
		done
	}

	# shellcheck disable=SC2329
	unset() {
		builtin unset "${@?}" || return
		local tmux_cmd="tmux"
		[[ -z "$TMUX" ]] && tmux_cmd=:

		for arg in "$@"; do
			[[ "$arg" =~ "-" ]]	&& continue

			$tmux_cmd setenv -u "$arg"
		done
	}
}

if [[ -n "$VIRTUAL_ENV" ]]; then
	deactivate() {
		local tmux_cmd="tmux"
		[[ -z "$TMUX" ]] && tmux_cmd=:

		_tmux_export_unset

		eval "$($tmux_cmd show -v @venv-deactivate)"
		_deactivate

		$tmux_cmd set -u @venv-deactivate

		unset -f export unset _deactivate deactivate
	}
fi

# Activate python venv for a tmux session
source-venv() {
	local venv="${1:-.}"
	local tmux_cmd="tmux"
	[[ -z "$TMUX" ]] && tmux_cmd=:

	_tmux_export_unset

	if source "$venv/bin/activate"; then
		renamefunc deactivate _deactivate
		$tmux_cmd set @venv-deactivate "$(declare -f _deactivate)"
		source "${BASH_SOURCE[0]}"

		export _OLD_VIRTUAL_PATH
		export _OLD_VIRTUAL_PYTHONHOME
		export _OLD_VIRTUAL_PS1
	fi

	# Preserve _deactivate while outside of tmux
	[[ -n "$TMUX" ]] && unset -f _deactivate
	unset -f export unset
}
