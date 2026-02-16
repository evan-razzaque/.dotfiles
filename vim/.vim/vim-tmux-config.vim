" Navigate to tmux/vim pane in insert mode.
function! s:tmux_nav(direction)
	let s:tmux_pane_id_cmd = "tmux display-message -p '#{pane_id}'"

	silent! execute(":TmuxNavigate" . a:direction)

	return ""
endfunction

" Hide one shot normal command when using vim-tmux-navigator
" Only has an effect with vim to vim insert mode navigation
" let g:airline_mode_map = {
" 	\ 'niI' : 'INSERT',
" 	\ 'niR' : 'REPLACE',
" \}

let g:tmux_navigator_no_mappings = 1

" Insert mode (vim to tmux)
inoremap <silent> <expr> <C-a><C-h> <SID>tmux_nav("Left")
inoremap <silent> <expr> <C-a><C-j> <SID>tmux_nav("Down")
inoremap <silent> <expr> <C-a><C-k> <SID>tmux_nav("Up")
inoremap <silent> <expr> <C-a><C-l> <SID>tmux_nav("Right")
inoremap <silent> <expr> <C-a><C-\> <SID>tmux_nav("Previous")

" Normal mode (vim to tmux and vim to vim)
nnoremap <silent> <C-a><C-h> :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> <C-a><C-j> :<C-U>TmuxNavigateDown<cr>
nnoremap <silent> <C-a><C-k> :<C-U>TmuxNavigateUp<cr>
nnoremap <silent> <C-a><C-l> :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> <C-a><C-\> :<C-U>TmuxNavigatePrevious<cr>

" Command mode (vim to tmux)
cnoremap <silent> <expr> <C-a><C-h> <SID>tmux_nav("Left")
cnoremap <silent> <expr> <C-a><C-j> <SID>tmux_nav("Down")
cnoremap <silent> <expr> <C-a><C-k> <SID>tmux_nav("Up")
cnoremap <silent> <expr> <C-a><C-l> <SID>tmux_nav("Right")
cnoremap <silent> <expr> <C-a><C-\> <SID>tmux_nav("Previous")

" Visual mode (vim to tmux)
vnoremap <silent> <expr> <C-a><C-h> <SID>tmux_nav("Left")
vnoremap <silent> <expr> <C-a><C-j> <SID>tmux_nav("Down")
vnoremap <silent> <expr> <C-a><C-k> <SID>tmux_nav("Up")
vnoremap <silent> <expr> <C-a><C-l> <SID>tmux_nav("Right")
vnoremap <silent> <expr> <C-a><C-\> <SID>tmux_nav("Previous")
