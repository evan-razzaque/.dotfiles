#!/usr/bin/env bash
#
# ~/.bash_functions

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
