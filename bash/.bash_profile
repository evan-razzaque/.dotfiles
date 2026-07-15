#
# ~/.bash_profile
#
# shellcheck disable=SC1091,SC1090
#

append-paths() {
	local path_name="$1"

	shift 1
	local p paths=("$@")

	for p in "${paths[@]}"; do
		if [[ "${!path_name}" == *"$p"* ]]; then
			continue
		fi

		# Prevent leading ':'
		if [[ -n "${!path_name}" ]]; then
			export "$path_name=${!path_name}:"
		fi

		export "$path_name=${!path_name}$p"
	done
}

append-paths PATH ~/.bin ~/.local/bin
append-paths PYTHONPATH "$(find /usr/local/lib -name "site-packages" 2> /dev/null)"
append-paths PATH ~/.config/composer/vendor/bin

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

