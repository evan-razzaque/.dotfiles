function! s:get_tmux_pane_id()
	return system("tmux display-message -p '#{pane_id}'")
endfunction

" Navigate to tmux pane in insert/command/visual mode
function! s:tmux_nav(mode, direction)
	let s:old_pane_id = s:get_tmux_pane_id()
	silent! execute(":TmuxNavigate" . a:direction)

	" Go back to insert mode if navigating to different tmux pane
	if a:mode == "i" && s:get_tmux_pane_id() != s:old_pane_id
		call feedkeys('a')
	endif

	return ""
endfunction

let g:tmux_navigator_no_mappings = 1

" Insert mode (vim to tmux and vim to vim)
inoremap <silent> <C-a><C-h> <esc>:call <SID>tmux_nav("i", "Left")<cr>
inoremap <silent> <C-a><C-j> <esc>:call <SID>tmux_nav("i", "Down")<cr>
inoremap <silent> <C-a><C-k> <esc>:call <SID>tmux_nav("i", "Up")<cr>
inoremap <silent> <C-a><C-l> <esc>:call <SID>tmux_nav("i", "Right")<cr>
" inoremap <silent> <C-a><C-\> :call <SID>tmux_nav("i", "Previous")<cr>

" Normal mode (vim to tmux and vim to vim)
nnoremap <silent> <C-a><C-h> :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> <C-a><C-j> :<C-U>TmuxNavigateDown<cr>
nnoremap <silent> <C-a><C-k> :<C-U>TmuxNavigateUp<cr>
nnoremap <silent> <C-a><C-l> :<C-U>TmuxNavigateRight<cr>
" nnoremap <silent> <C-a><C-\> :<C-U>TmuxNavigatePrevious<cr>

" Command mode (vim to tmux)
cnoremap <silent> <expr> <C-a><C-h> <SID>tmux_nav("c", "Left")
cnoremap <silent> <expr> <C-a><C-j> <SID>tmux_nav("c", "Down")
cnoremap <silent> <expr> <C-a><C-k> <SID>tmux_nav("c", "Up")
cnoremap <silent> <expr> <C-a><C-l> <SID>tmux_nav("c", "Right")
" cnoremap <silent> <expr> <C-a><C-\> <SID>tmux_nav("c", "Previous")

" Visual mode (vim to tmux)
vnoremap <silent> <expr> <C-a><C-h> <SID>tmux_nav("v", "Left")
vnoremap <silent> <expr> <C-a><C-j> <SID>tmux_nav("v", "Down")
vnoremap <silent> <expr> <C-a><C-k> <SID>tmux_nav("v", "Up")
vnoremap <silent> <expr> <C-a><C-l> <SID>tmux_nav("v", "Right")
" vnoremap <silent> <expr> <C-a><C-\> <SID>tmux_nav("v", "Previous")
