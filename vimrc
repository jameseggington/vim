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
" Opens your vimrc file in a new buffer
nnoremap <leader>ev :e $MYVIMRC<cr>
" Sources your vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" Opens the file you use for reminding myself how to do something in vim
nnoremap <leader>lu :e ~/.vim/vim-lookups.md<cr>
" Opens a file for taking notes in a new buffer
nnoremap <leader>n :e ~/Documents/notes.md<cr>
" Makes jk exit insert mode
inoremap jk <esc>
" Forces using jk to exit insert mode by removing mapping for <esc>
inoremap <esc> <nop>

" Maps t to toggle char case then move back to it
nnoremap t ~h

nnoremap <leader>gs :!git status
nnoremap <leader>ga :!git add -A
