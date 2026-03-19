#
# ~/.bash_functions
#

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
		# Don't export empty variables
		[[ -z "${!1}" ]] && return

		builtin export "${1?}"
		if [[ -n "$TMUX" ]]; then
			tmux setenv "$1" "${!1}"
		fi
	}

	unset() {
		builtin unset "$@"
		if [[ -n "$TMUX" ]]; then
			local args="$*"
			tmux setenv -u "${args//@(-f|-v|-n)/}"
		fi
	}
}

# Activate python venv for a tmux session
source-venv() {
	local venv="${1:-.}"

	_tmux_export_unset

	if source "$venv/bin/activate"; then
		tmux set @venv-deactivate "$(declare -f deactivate)"
	fi

	export _OLD_VIRTUAL_PATH
	export _OLD_VIRTUAL_PYTHONHOME
	export _OLD_VIRTUAL_PS1

	builtin unset -f export unset
}

# Deactivate python venv for a tmux session
deactivate-venv() {
	_tmux_export_unset

	eval "$(tmux show -v @venv-deactivate)"
	deactivate

	tmux set -u @venv-deactivate

	builtin unset -f export unset
}
