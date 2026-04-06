#!/usr/bin/env bash

DOTFILES_PATH="$1"
if [[ -z "$DOTFILES_PATH" ]]; then
	echo "Missing argument" >&2
	exit 1
fi

DOTFILES_PATH=$(readlink -f "$DOTFILES_PATH")
cd $(dirname "$0")

if [[ "$DOTFILES_PATH" == $(readlink -f "$PWD") ]]; then
	echo "Cannot use existing dotfiles directory" >&2
	exit 1
fi

mkdir "$DOTFILES_PATH" || exit $?
mkdir "$DOTFILES_PATH/.ignore"

cp -- *.sh README.md .gitignore "$DOTFILES_PATH"
cp .ignore/README.txt .ignore/.stow-local-ignore "$DOTFILES_PATH/.ignore"

cd "$DOTFILES_PATH"

git init
git add .
git commit -m "Initial commit"
