#
# ~/.bash_profile
#

append-paths() {
	local path_name="$1"

	shift 1
	local paths=("$@")

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

export MAKEFLAGS="--jobs=$(nproc) --output-sync"
export EDITOR=vim
export TIME_STYLE=long-iso

# User-defined environment variables
if [ -f ~/.bash_env ]; then
	set -o allexport
	source ~/.bash_env
	set +o allexport
fi

[[ -f ~/.bash_profile_user ]] && . ~/.bash_profile_user
unset -f append-paths

[[ -f ~/.bashrc ]] && . ~/.bashrc

