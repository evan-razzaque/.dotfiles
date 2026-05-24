#!/usr/bin/env bash

# Takes stow output from stdin, filters out packages that are restowed and
# ignores package config adoption (since we use git restore).
filter-stow-output() {
	grep -vP '^MV' |\
		cat -n | \
		sed -E 's/(.*)LINK(:\s\S+)(.*)(\(reverts.*)/\1UNLINK\2/g' | \
		sort -sk 3,3 | \
		uniq -uf 1 | \
		sort -n | \
		cut -f 2
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

	git clean -fd .ignore &>/dev/null
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
	git clean -nd .ignore | sed 's|Would remove .ignore/|Not removing |g'
}

stow-preview() {
	_stow --restow --simulate
	git clean -nd .ignore | sed 's|Would remove .ignore/|Ignoring |g'
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
