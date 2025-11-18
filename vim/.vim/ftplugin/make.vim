setlocal tabstop=4 shiftwidth=4 softtabstop=0 noexpandtab

" Highlight nested conditionals
match PreCondit /^\s*\(ifn\=\(eq\|def\)\>\|else\(\s\+ifn\=\(eq\|def\)\)\=\>\|endif\>\)/

