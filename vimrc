set nocompatible

syntax on filetype plugin indent on
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
set shiftwidth=2
set laststatus=2
set statusline=%<%f\ %y%{fugitive#statusline()}%q%=\ %10(%3l,%02c%)
set noswapfile
set sessionoptions="options,windows,localoptions,help,buffers"
set splitright

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
nnoremap <leader>ej :call OpenJournalForToday()<cr> 

"File related commands
nnoremap <leader>ff :fin 
nnoremap <leader>fe :e 
nnoremap <leader>fv :vsp 
nnoremap <leader>fl :Explore<cr>

"Buffer related commands
nnoremap <leader>bb :ls<cr>:b 
nnoremap <leader>bv :ls<cr>:vertical sb 
nnoremap <leader>bd :ls<cr>:bw 
nnoremap <leader>bl :b#<cr>
nnoremap <leader>bk :bw %<cr>
nnoremap <leader>br :2,bdelete<cr>

"Make related commands
nnoremap <leader>cm :silent make\|redraw!<cr>
nnoremap <leader>cs :silent make\ start\|redraw!<cr>
nnoremap <leader>co :copen<cr>
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprevious<cr>
nnoremap <leader>cc :cclose<cr>

nnoremap <leader>ds :!vagrant up<cr>
nnoremap <leader>de :!vagrant halt<cr>

"Window related commands
nnoremap <leader>ws :split<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

"Write related commands
cmap w!! w !sudo tee >/dev/null %

"Autocommand to save session on exit and load it again on opening Vim.
"au VimEnter * nested :call LoadSession()
"au VimLeave * :call MakeSession()
"function! MakeSession()
"  let b:filename = $HOME . "/session.vim"
"  exe "mksession! " . b:filename
"endfunction
"
"function! LoadSession()
"  let b:sessionfile = $HOME . "/session.vim"
"  if (filereadable(b:sessionfile))
"    exe 'source ' b:sessionfile
"		exe "bfirst"
"  else
"    echo "No session loaded."
"  endif
"endfunction

"Simple project management
"Projects are configured through vim scripts in the project's directory
if has("autocmd")
	augroup projects
		autocmd VimEnter * silent! exe 'source ' . getcwd() . '/project.vim'
	augroup END
endif

"Simple templating
"Loads the contents of a template file if there is one, replacing all
"characters between <<>> with the result of executing those contents within
"Vim.
if has("autocmd")
	augroup templates
		autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/template.' .  FullExtension(expand('<afile>:t'))
		autocmd BufNewFile * %substitute:<<\(.\{-}\)>>:\=eval(submatch(1)):ge
	augroup END
endif

"A replacement for the tempremental ftplugin system for loading filetype
"specific config
if has("autocmd")
	augroup filetypeConfig
		autocmd BufNewFile,BufRead * silent! exe 'source ' $HOME . '/.vim/filetypes/' .  expand('<afile>:e') . '.vim'
		autocmd BufNewFile,BufRead * silent! exe 'source ' $HOME . '/.vim/filetypes/' .  FullExtension(expand('<afile>:t')) . '.vim'
	augroup END
endif

"Retrieve the full file extension (all characters after the first dot), as
"opposed to Vim's interpretation (all chars after the last dot)
function! FullExtension(filename)
	return join(split(a:filename, '\.')[1:], '.')
endfunction

"Open a journal file for today's date
function! OpenJournalForToday()
	let b:journalfile = strftime("%Y%m%d") . ".journal.md"
	let b:directory = $HOME . "/Documents/journal/"
	if(!isdirectory(b:directory))
		call mkdir(b:directory, "p")
	endif
	exe "e " . b:directory . b:journalfile
endfunction
