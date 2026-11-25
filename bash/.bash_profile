#
# ~/.bash_profile
#
# shellcheck disable=SC1091,SC1090
#

# Append paths to $1
# @param $1 The name of the path variable to append to
# @param $@ The paths to append
append_paths() {
	local path_name="$1"
	local -a paths
	local p

	shift 1
	paths=("$@")

	for p in "${paths[@]}"; do
		[[ "${!path_name}" == *"$p"* ]] && continue

		export "$path_name=${!path_name:+${!path_name}:}$p"
	done
}

# Prepend paths to $1
# @param $1 The name of the path variable to prepend to
# @param $@ The paths to prepend
prepend_paths() {
	local path_name="$1"
	local -a paths
	local p

	shift 1
	paths=("$@")

	for p in "${paths[@]}"; do
		[[ "${!path_name}" == *"$p"* ]] && continue

		export "$path_name=$p${!path_name:+:${!path_name}}"
	done

}

append_paths PATH ~/.bin ~/.local/bin
append_paths PYTHONPATH "$(find /usr/local/lib -name "site-packages" 2> /dev/null)"
append_paths PATH ~/.config/composer/vendor/bin

export MAKEFLAGS="--jobs=$(nproc)"
export EDITOR=vim
export TIME_STYLE=long-iso

BASH_CONFIG=~/.config/bash

# User-defined environment variables
if [ -f "$BASH_CONFIG/env" ]; then
	set -o allexport
	source "$BASH_CONFIG/env"
	set +o allexport
fi

[[ -f "$BASH_CONFIG/profile_user" ]] && . "$BASH_CONFIG/profile_user"

unset BASH_CONFIG
unset -f append-paths

[[ -f ~/.bashrc ]] && . ~/.bashrc

