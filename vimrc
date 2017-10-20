set nocompatible

syntax on
filetype plugin indent on
colorscheme elflord
set number
set relativenumber
set nowrap
set path+=**
set wildmenu
set autoindent
set smartindent
set hidden "allows 'abandoning' a buffer without saving
set incsearch
set tabstop=2
set laststatus=2
set statusline=%<%f\ %y%{fugitive#statusline()}%q%=\ %10(%3l,%02c%)
set noswapfile

let g:netrw_banner=0
let g:netrw_liststyle=3


let mapleader = ";"
" Makes jk exit insert mode
inoremap jk <esc>l
" Forces using jk to exit insert mode by removing mapping for <esc>
inoremap <esc> <nop>

" Maps t to toggle char case then move back to it
nnoremap t ~h

"Editor commands
nnoremap <leader>eq :qa!<cr>
nnoremap <leader>ew :w<cr>
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
nnoremap <leader>cs :silent make\ start\|redraw!<cr>
nnoremap <leader>co :copen<cr>
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprevious<cr>
nnoremap <leader>cc :cclose<cr>

"Autocommand to save session on exit and load it again on open
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction
au VimEnter * nested :call LoadSession()
au VimLeave * :call MakeSession()

