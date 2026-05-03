" Get highlight group under cursor
function! SynStack()
    CocCommand semanticTokens.inspect
		sleep 50ms

    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if (executable("node"))
  nnoremap gm :call SynStack()<CR>
endif
