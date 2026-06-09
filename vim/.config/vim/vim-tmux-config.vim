function! s:tmux_cmd(args)
	return system("tmux " . a:args)
endfunction

function! s:get_tmux_prefix()
	let l:key = trim(s:tmux_cmd("display -p '#{prefix}'"))

	if l:key == "None"
		return ""
	endif

	if match(l:key, '\v(C-|\^|M-|S-)') != -1
		return "<" . l:key . ">"
	endif

	return l:key
endfunction

function! s:tmux_get_pane_id()
	return trim(s:tmux_cmd("display-message -p '#{pane_id}'"))
endfunction

function! s:tmux_nav_set_vim_pid()
	let s:tmux_pane_id = $TMUX_PANE
	call s:tmux_cmd("set -t " . s:tmux_pane_id . " -p @tmux-nav-vim " . getpid())

	return ""
endfunction

function! s:tmux_nav_unset_vim_pid()
	call s:tmux_cmd("set -t " . s:tmux_pane_id . " -up @tmux-nav-vim")

	return ""
endfunction

" Wrapper function for :TmuxNavigate<direction>
function! s:tmux_nav(direction, mode = "")
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

let s:tmux_prefix = ""

if !empty($TMUX)
	let s:tmux_prefix = s:get_tmux_prefix()

	cnoreabbrev <expr> shell getcmdtype() == ":" && getcmdline() == 'shell'
				\? <SID>tmux_nav_unset_vim_pid() . 'shell' : 'shell'

	augroup TmuxNavigateSetPid
		autocmd!
		autocmd VimEnter,VimResume,ShellCmdPost * silent! call s:tmux_nav_set_vim_pid()
		autocmd VimLeave,VimSuspend * silent! call s:tmux_nav_unset_vim_pid()
	augroup END
endif

let g:tmux_navigator_no_mappings = 1

let s:nav_binds = [
			\[s:tmux_prefix . "<C-h>", "Left"],
			\[s:tmux_prefix . "<C-j>", "Down"],
			\[s:tmux_prefix . "<C-k>", "Up"],
			\[s:tmux_prefix . "<C-l>", "Right"]
\]

for [s:key, s:direction] in s:nav_binds
	execute "inoremap <silent> ".s:key.
				\" <esc>:call <SID>tmux_nav('".s:direction."', 'i')<cr>"

	execute "nnoremap <silent> ".s:key.
				\" :<C-U>TmuxNavigate".s:direction."<cr>"

	execute "cnoremap <silent> <expr> ".s:key.
				\" <SID>tmux_nav('".s:direction."')"

	execute "vnoremap <silent> <expr> ".s:key.
				\" <SID>tmux_nav('".s:direction."')"

	execute "tnoremap <silent> <expr> ".s:key.
				\" '\<C-w>:\<C-U>TmuxNavigate".s:direction."\<cr>'"
endfor
