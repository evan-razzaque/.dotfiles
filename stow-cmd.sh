#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# Remove redundant output from stow. Input is passwd via stdin.
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

	git clean --force .ignore &>/dev/null
}

stow-install() {
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
	git clean --dry-run .ignore | sed 's|Would remove .ignore/|Not removing |g'
}

stow-preview() {
	_stow --restow --simulate
	git clean --dry-run .ignore | sed 's|Would remove .ignore/|Ignoring |g'
}

# Default action
eval "$(basename "$(realpath "$0")")() { stow-install \$@; }"

# shellcheck disable=2155,2164
main() {
	local stow_ignore=".stow-global-ignore"
	local action=$(basename "$0")
	local has_stow_ignore=false

	if [[ -e "$HOME/$stow_ignore" ]]; then
		has_stow_ignore=true
	fi

	# For some reason, .stow-global-ignore HAS to be in $HOME,
	# so we temporarily create a symlink in $HOME (because $HOME clutter bad)
	! "$has_stow_ignore" && ln -s --relative "$stow_ignore" "$HOME"

	PACKAGES=(*/)
	PACKAGES=("${@:-${PACKAGES[@]}}")

	"stow-$action" "$@"

	! "$has_stow_ignore" && rm "$HOME/$stow_ignore"
}

main "$@"
