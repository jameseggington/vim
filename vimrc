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

let mapleader = ";"
" Opens your vimrc file in a new buffer
nnoremap <leader>ev :e $MYVIMRC<cr>
" Sources your vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" Makes jk exit insert mode
inoremap jk <esc>
" Forces using jk to exit insert mode by removing mapping for <esc>
inoremap <esc> <nop>

" Maps t to toggle char case then move back to it
nnoremap t ~h

"File related commands
nnoremap <leader>ff :fin 
nnoremap <leader>fe :e 
nnoremap <leader>fl :Explore<cr>
nnoremap <leader>fd :call delete(@%)|bdelete!

"Buffer related commands
nnoremap <leader>bb :ls<cr>:b 
nnoremap <leader>bd :ls<cr>:bd 
nnoremap <leader>bk :bdelete %<cr>
nnoremap <leader>br :2,bdelete<cr>

"Opening files for editing
nnoremap <leader>ol :e ~/.vim/vim-lookups.md<cr>
nnoremap <leader>on :e ~/Documents/notes.md<cr>
