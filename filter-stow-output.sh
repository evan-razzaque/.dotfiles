#!/bin/bash

# Takes stow output from stdin, filters out packages that are restowed and
# ignores package config adoption (since we use git restore).
grep -vP '^MV' |\
	cat -n | \
	sed -E 's/(.*)LINK(:\s\S+)(.*)(\(reverts.*)/\1UNLINK\2/g' | \
	sort -sk 3,3 | \
	uniq -uf 1 | \
	sort -n | \
	cut -f 2

