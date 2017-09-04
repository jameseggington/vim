set nocompatible
syntax on
filetype plugin indent on
set number
set relativenumber
set statusline+=%F
set nowrap
set path+=**
set wildmenu
set smartindent
colorscheme apprentice

let g:netrw_banner=0
let g:netrw_liststyle=3

let mapleader = ","
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>lu :e ~/.vim/vim-lookups.md<cr>
inoremap jk <esc>
inoremap <esc> <nop>

nnoremap t ~h
