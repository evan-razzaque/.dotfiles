#!/usr/bin/env bash

PACKAGES=(*/)
PACKAGES=("${@:-${PACKAGES[@]}}")

# Don't install .ignore/
shopt -u dotglob

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
	local flags=("$@")

	stow -t ~ --adopt --no-folding -v "${flags[@]}" "${PACKAGES[@]}" 2>&1 \
		| filter-stow-output
}

stow-cmd() {
	local operation="$1"

	git stash &>/dev/null

	_stow "$operation"

	# Restore changes from stow and any files ignored during installation
	git restore .
	git clean -fd .ignore

	git stash pop &>/dev/null
}

stow-cmd-preview() {
	local operation="$1"
	_stow -n "$operation"
}
