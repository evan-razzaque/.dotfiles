#!/usr/bin/env bash

cd $(dirname $0)

main() {
	local flags="$1"
	shift 1

	stow -t ~ --adopt --no-folding -v "$flags" "$@" 2>&1 | ./filter-stow-output.sh
}

main "$@"
