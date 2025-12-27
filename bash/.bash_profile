#
# ~/.bash_profile
#

append-paths() {
	local args=("$@")
	local path_name="$1"

	local paths="${args[@]:1}"

	for p in $paths; do
		if [[ ! "${!path_name}" =~ "$p" ]]; then
			export $path_name="${!path_name}:$p"
		fi
	done
}

append-paths PATH ~/.bin ~/.local/bin

export MAKEFLAGS="--jobs=$(nproc) --output-sync"

export EDITOR=vim
export TIME_STYLE=long-iso

export PYTHONPATH=$PYTHONPATH:$(find /usr/local/lib -name "site-packages" 2> /dev/null)

unset -f append-paths

[[ -f ~/.bashrc ]] && . ~/.bashrc

