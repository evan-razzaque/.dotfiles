#!/usr/bin/env bash
#
# Source (the command) warnings
# shellcheck disable=SC1090,SC1091

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

if [[ -n "$VIRTUAL_ENV" ]] && [[ -n "$_TMUX_SOURCE_VENV" ]]; then
	deactivate() {
		local tmux_cmd="tmux"
		[[ -z "$TMUX" ]] && tmux_cmd=:

		_tmux_export_unset

		eval "$($tmux_cmd show -v @venv-deactivate)"
		_deactivate

		$tmux_cmd set -u @venv-deactivate

		unset _TMUX_SOURCE_VENV
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

		_TMUX_SOURCE_VENV=1
		source "${BASH_SOURCE[0]}"

		export _OLD_VIRTUAL_PATH
		export _OLD_VIRTUAL_PYTHONHOME
		export _OLD_VIRTUAL_PS1
		export _TMUX_SOURCE_VENV
	fi

	# Preserve _deactivate while outside of tmux
	[[ -n "$TMUX" ]] && unset -f _deactivate
	unset -f export unset
}
