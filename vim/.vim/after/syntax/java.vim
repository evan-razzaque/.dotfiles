let g:jb_style='dark'
let g:jb_enable_italics=1

let g:jb_color_overrides={
	\"type": {"gui": "#CF8E6D", "cterm": "224"}
\}

" Remove background color from status line to match colorscheme
function! AirlineThemePatch(palette)
	let a:palette["normal"]["airline_c"][1] = "NONE"
	let a:palette["insert"]["airline_c"][1] = "NONE"
	let a:palette["visual"]["airline_c"][1] = "NONE"
endfunction

let g:airline_theme_patch_func = 'AirlineThemePatch'
let g:airline_theme='catppuccin_macchiato'
color jb

hi Normal guibg=#1E1F22
hi CursorLine guibg=#26282e term=none cterm=none

hi link CocSemTypeClass Normal
hi link CocSemTypeParameter Normal
hi link CocSemTypeVariable Normal
hi link CocSemTypeProperty Constant

hi link CocSemTypeMethod Normal
hi link CocSemTypeModMethodDeclaration Identifier

hi link Keyword Type
hi link javaConstant Keyword
hi link javaOperator Keyword

hi JBError cterm=undercurl ctermul=9 gui=underline guifg=#F75464
hi JBWarning cterm=undercurl ctermul=11 gui=undercurl guifg=#F2C55C
