unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

" --Theme--
set termguicolors
color catppuccin_macchiato

" --Settings--
set number
set relativenumber
set shiftwidth=4
set tabstop=4 
set visualbell hidden 
set t_vb=

" --Mappings--

" Copy to system clipboard
vnoremap <C-y> "+y

