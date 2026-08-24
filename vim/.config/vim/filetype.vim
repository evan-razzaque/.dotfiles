if exists("did_load_file_types")
	finish
endif

augroup filetypedetect
	au! BufRead,BufNewFile .stow-local-ignore setfiletype conf
augroup END
