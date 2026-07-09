#!/usr/bin/env bash
#
# Source (the command) warnings
# shellcheck disable=SC1090,SC1091

[[ -z "$TMUX" ]] && return

# Prevent a function from being invoked outside of a function
_tmux_guard_func() {
	if [[ -z "${FUNCNAME[1]}" || -z "${FUNCNAME[2]}" ]]; then
		echo "Cannot be called outside of a function" >&2
		return 1
	fi
}

_tmux_bash_func_export_name() {
	_tmux_guard_func || return

	local name=${1?}
	echo "BASH_FUNC_$name%%"
}

# Export and unset environment variables for tmux
_tmux_export_unset() {
	_tmux_guard_func || return

	export() {
		builtin export "${@?}" || return
		local tmux_cmd="tmux"

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

		for arg in "$@"; do
			[[ "$arg" =~ "-" ]]	&& continue

			$tmux_cmd setenv -u "$arg"
		done
	}
}

if [[ -n "$VIRTUAL_ENV" ]] && [[ -n "$_TMUX_SOURCE_VENV" ]]; then
	deactivate() {
		local tmux_cmd="tmux"

		_tmux_export_unset

		# eval "$($tmux_cmd show -v @venv-deactivate)"
		_deactivate

		$tmux_cmd setenv -u "$(_tmux_bash_func_export_name _deactivate)"

		unset _TMUX_SOURCE_VENV
		unset -f export unset _deactivate deactivate
	}
fi

# Activate python venv for a tmux session
source-venv() {
	local venv="${1:-.}"
	local tmux_cmd="tmux"

	_tmux_export_unset

	if source "$venv/bin/activate"; then
		renamefunc deactivate _deactivate
		$tmux_cmd setenv "$(_tmux_bash_func_export_name _deactivate)" "() {  \
			$(declare -f _deactivate | tail -n +3)"

		_TMUX_SOURCE_VENV=1
		source "${BASH_SOURCE[0]}"

		export _OLD_VIRTUAL_PATH
		export _OLD_VIRTUAL_PYTHONHOME
		export _OLD_VIRTUAL_PS1
		export _TMUX_SOURCE_VENV
	fi

	unset -f export unset
}
