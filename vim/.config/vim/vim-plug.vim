Plug 'arcticicestudio/nord-vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'devsjc/vim-jb'
Plug 'tpope/vim-commentary'
Plug 'ryvnf/readline.vim'

if (executable("deno"))
	Plug 'vim-denops/denops.vim'
	Plug 'kg8m/vim-detect-indent'
	silent! source $MYVIMDIR/vim-detect-indent-config.vim
endif

if (executable("ag"))
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
endif

if (executable("node"))
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'jwalton512/vim-blade'
	silent! source $MYVIMDIR/coc-config.vim
endif

if (executable("tmux"))
	Plug 'christoomey/vim-tmux-navigator'
	silent! source $MYVIMDIR/vim-tmux-config.vim
endif
