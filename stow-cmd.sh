#!/usr/bin/env bash

# Takes stow output from stdin, filters out packages that are restowed and
# ignores package config adoption (since we use git restore).
filter-stow-output() {
	grep --invert-match --perl-regexp '^MV' |\
		cat --number | \
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
	local action=$(basename "$0")

	cd "$(dirname "$0")"

	PACKAGES=(*/)
	PACKAGES=("${@:-${PACKAGES[@]}}")

	"stow-$action" "$@"
}

main "$@"
