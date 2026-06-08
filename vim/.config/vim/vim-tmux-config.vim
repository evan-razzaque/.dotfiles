function s:log(msg)
	if empty($VIM_TMUX_NAV_DEBUG)
		return
	endif

	call system("logger -t vim-tmux-nav '" . escape(msg, '"') . "'")
endfunction

function! s:tmux_get_pane_id()
	return trim(system("tmux display-message -p '#{pane_id}'"))
endfunction

function! s:tmux_nav_set_vim_pid()
	let s:tmux_pane_id = $TMUX_PANE
	call system("tmux set -t " . s:tmux_pane_id . " -p @tmux-nav-vim " . getpid())

	return ""
endfunction

function! s:tmux_nav_unset_vim_pid()
	call system("tmux set -t " . s:tmux_pane_id . " -up @tmux-nav-vim")
	call delete(fnameescape(s:tmux_nav_file))

	return ""
endfunction

" Navigate to tmux pane in insert/command/visual mode
function! s:tmux_nav(mode, direction)
	silent! execute(":TmuxNavigate" . a:direction)

	if empty($TMUX)
		return ""
	endif

	" Go back to insert mode if navigating to different tmux pane
	if a:mode == "i" && s:tmux_get_pane_id() != s:tmux_pane_id
		call feedkeys('a')
	endif

	return ""
endfunction

if !empty($TMUX)
	cnoreabbrev <expr> shell getcmdtype() == ":" && getcmdline() == 'shell'
				\? <SID>tmux_nav_unset_vim_pid() . 'shell' : 'shell'

	augroup TmuxNavigateSetPid
		autocmd!
		autocmd VimEnter,VimResume,ShellCmdPost * silent! call s:tmux_nav_set_vim_pid()
		autocmd VimLeave,VimSuspend * silent! call s:tmux_nav_unset_vim_pid()
	augroup END
endif

let g:tmux_navigator_no_mappings = 1
let s:tmux_uid = trim(system("id -u"))
let s:tmux_nav_file = "/tmp/tmux-nav-vim-" . s:tmux_uid . "-" . getpid()

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

function s:handle_tmux_nav_more_prompt()
	if empty($TMUX)
		return
	endif

	let more_prompt = "-- More --"
	let line = ""

	for i in range(1, len(more_prompt))
		let line .= nr2char(screenchar(&lines, i))
	endfor

	if line != more_prompt
		return
	endif

	let direction = trim(system("flock " . s:tmux_nav_file . " cat " . s:tmux_nav_file))
	if direction == ""
		return
	endif

	silent execute(":TmuxNavigate" . direction)
endfunction

augroup SIGUSR1
	autocmd!
	autocmd SigUSR1 * call s:handle_tmux_nav_more_prompt()
augroup END
