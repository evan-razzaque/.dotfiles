#!/usr/bin/env bash
#
# Source (the command) warnings
# shellcheck disable=SC1090,SC1091

[[ -z "$TMUX" ]] && return

# Prevent a function from being invoked outside of a function.
# To use this function, simply insert the following at the top
# of a function:
# _tmux_guard_func || return
_tmux_guard_func() {
	if [[ -z "${FUNCNAME[1]}" || -z "${FUNCNAME[2]}" ]]; then
		echo "Cannot be called outside of a function" >&2
		return 1
	fi
}

# Run a tmux command
_tmux() {
	tmux "$@"
}

# Get the name of an exported shell function.
#
# @param $1 The function name
# var[out] REPLY The exported function name
_tmux_bash_func_export_name() {
	local name=${1?}
	REPLY="BASH_FUNC_$name%%"
}

# Export shell function(s) to tmux session environment.
#
# @param $@ The function(s) to export
_tmux_export_func() {
	_tmux_guard_func || return

	local func export_func

	for func in "$@"; do
		builtin export -f "${func?}" || continue

		_tmux_bash_func_export_name "$func"
		export_func=$REPLY

		_tmux setenv "$export_func" "$(printenv "$export_func")"
	done

}

# Unset shell function(s) from tmux session environment.
#
# @param $@ The function(s) to unset
_tmux_unset_func() {
	_tmux_guard_func || return

	local func export_func

	for func in "$@"; do
		declare -pf "${func?}" &>/dev/null || continue
		builtin unset -f "${func}"

		_tmux_bash_func_export_name "$func"
		export_func=$REPLY

		_tmux setenv -u "$export_func"
	done
}

# Define functions to update tmux environment variables along
# with the shell environment.
_tmux_export_unset() {
	_tmux_guard_func || return

	export() {
		builtin export "${@?}" || return

		for arg in "$@"; do
			[[ "$arg" =~ "-" ]]	&& continue

			value=${arg#*=}
			name=${arg%"=$value"}
			[[ "$value" == "$arg" ]] && value=${!name}

			if [[ -z "$value" ]]; then
				builtin unset "$name"
				continue
			fi

			_tmux setenv "$name" "$value"
		done
	}

	# shellcheck disable=SC2329
	unset() {
		builtin unset "${@?}" || return

		for arg in "$@"; do
			[[ "$arg" =~ "-" ]]	&& continue

			_tmux setenv -u "$arg"
		done
	}
}

# Activate python venv (virtual environment) for the active tmux session.
# This will define two functions. The first function is deactivate, which will
# deactivate the python venv for the current shell and tmux session (other
# existing panes will not be affected). And the second function is _deactivate,
# which will only deactivate the venv for the current shell.
#
# @param $1 The python venv activation script (<venv>/bin/activate), or the
# venv directory itself.
source-venv() {
	local venv_script="${1:-.}"
	local rc

	[[ -d "$venv_script" ]] && venv_script="$venv_script/bin/activate"
	_tmux_export_unset

	source "$venv_script"
	rc=$?

	if [[ $rc -eq 0 ]]; then
		renamefunc deactivate _deactivate

		# shellcheck disable=SC2329
		deactivate() {
			_tmux_export_unset
			_deactivate

			_tmux_unset_func _deactivate deactivate
			unset -f export unset
		}

		_tmux_export_func _deactivate deactivate

		export _OLD_VIRTUAL_PATH
		export _OLD_VIRTUAL_PYTHONHOME
		export _OLD_VIRTUAL_PS1
	fi

	unset -f export unset
	return $rc
}
