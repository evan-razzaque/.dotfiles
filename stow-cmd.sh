#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# trap-n command signal [activation_count]
# Run COMMAND after receiving SIGNAL_SPEC ACTIVATION_COUNT times.
# If ACTIVATION_COUNT is not provided, it will default to 1.
trap-n() {
	local cmd=${1?}
	local -u signal=${2?}
	local -i n=${3:-1}

	if (((n * 1) < 1)); then
		echo "$0: Invalid activation count" >&2
		return 1
	fi

	# Don't activate for this function
	if [[ "$signal" == "RETURN" ]]; then
		((n++))
	fi

	# shellcheck disable=SC2064
	trap "$cmd" "$signal" || return

	for ((i = 1; i < n; i++)) {
		trap -- "$(trap -p "$signal")" "$signal"
	}
}

setup-stow-ignore() {
	# For some reason, .stow-global-ignore HAS to be in $HOME,
	# so we temporarily create a symlink in $HOME (because $HOME clutter bad)
	if [[ ! -e "$HOME/$stow_ignore" ]] && [[ -f "$stow_ignore" ]]; then
		ln -s --relative "$stow_ignore" ~/
		trap-n "rm ~/$stow_ignore; trap - RETURN" RETURN 2
	fi
}

# Remove redundant output from stow. Input is passed via stdin.
filter-stow-output() {
	grep --invert-match --perl-regexp '^MV' |\
		cat --number | \

		# Ignore all packages that are restowed
		sed --regexp-extended 's/(.*)LINK(:\s\S+)(.*)(\(reverts.*)/\1UNLINK\2/g' | \
		sort --stable --key=3,3 | \
		uniq --unique --skip-fields=1 | \

		sort --numeric-sort | \
		cut --fields=2
}

_stow() {
	stow "$@" "${PACKAGES[@]}" 2>&1 | filter-stow-output
}

stow-cmd() {
	git add .

	_stow "$@"

	# Revert stow package adoption
	git restore .

	git restore --staged .
	git ls-files --deleted | xargs git restore &>/dev/null
}

stow-install() {
	setup-stow-ignore || return
	stow-cmd --restow

	for package in "${PACKAGES[@]}"; do
		local script="$package/install.sh"
		[[ -f $script ]] || continue
		"./$script"
	done
}

stow-uninstall() {
	for package in "${PACKAGES[@]}"; do
		local script="$package/uninstall.sh"
		[[ -f $script ]] || continue
		"./$script"
	done

	stow-cmd --delete
}

stow-uninstall-preview() {
	_stow --delete --simulate
}

stow-preview() {
	setup-stow-ignore || return
	_stow --restow --simulate
}

# Default action
eval "$(basename "$(realpath "$0")")() { stow-install \$@; }"

# shellcheck disable=2155,2164
main() {
	local stow_ignore=".stow-global-ignore"
	local action=$(basename "$0")

	PACKAGES=(*/)
	PACKAGES=("${@:-${PACKAGES[@]}}")

	"stow-$action" "$@"
}

main "$@"
