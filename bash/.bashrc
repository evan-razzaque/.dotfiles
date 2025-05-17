#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

_ln() {
	local LINK_DIR=$(echo ${@:$#} | sed "s/\/[^\/]*$//")

	if [[ $# -lt 2 ]]; then
		echo "lnp: missing target and link"
		exit 1
	fi

	# Checks if the link destination is in a directory
	if [[ ! -z $(echo $LINK_DIR | grep "/") ]]; then
		# Checks if the link directories exist
		if [[ ! -e $LINK_DIR ]]; then
			mkdir -p $LINK_DIR
		fi
	fi

	local cmd="ln $@"
	$cmd
}

alias ls='ls --color=auto'
alias la='ls -A'
alias lr='ls -R'
alias ll='la -lh'
alias grep='grep --color=auto'
alias vimsu='sudo -E vim'

PS1='[\u@\h \W]\$ '

fastfetch
