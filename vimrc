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
set hidden "allows 'abandoning' a buffer without saving
set incsearch
set tabstop=2
colorscheme elflord

let g:netrw_banner=0
let g:netrw_liststyle=3

let mapleader = ";"
" Makes jk exit insert mode
inoremap jk <esc>
" Forces using jk to exit insert mode by removing mapping for <esc>
inoremap <esc> <nop>

" Maps t to toggle char case then move back to it
nnoremap t ~h

"Editor commands
nnoremap <leader>eq :qa!<cr>
nnoremap <leader>ew :qa!<cr>
nnoremap <leader>es :source $MYVIMRC<cr>
nnoremap <leader>el :e ~/.vim/lookups.md<cr>
nnoremap <leader>en :e ~/Documents/notes.md<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>eh :h 

"File related commands
nnoremap <leader>ff :fin 
nnoremap <leader>fe :e 
nnoremap <leader>fv :vsp 
nnoremap <leader>fl :Explore<cr>

"Buffer related commands
nnoremap <leader>bb :ls<cr>:b 
nnoremap <leader>bd :ls<cr>:bd 
nnoremap <leader>bl :b#<cr>
nnoremap <leader>bk :bdelete %<cr>
nnoremap <leader>br :2,bdelete<cr>

"Make related commands
nnoremap <leader>cm :silent make\|redraw!<cr>
nnoremap <leader>co :copen<cr>
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprevious<cr>
nnoremap <leader>cc :cclose<cr>
