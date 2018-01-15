set nocompatible

syntax on
filetype plugin indent on
colorscheme monochrome
set number
set relativenumber
set nowrap
set path+=**
set wildmenu
set wildcharm=<Tab>
set autoindent
set smartindent
set hidden " allows 'abandoning' a buffer without saving
set incsearch
set tabstop=2
set shiftwidth=2
set laststatus=2
set statusline=%<%l/%L,%c\ in\ %f\ %=%{fugitive#statusline()}
set noswapfile
set splitright
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000

let g:netrw_banner=0
let g:netrw_liststyle=3

let mapleader = ";"
" Makes jk exit insert mode
inoremap jk <esc>l
" Forces using jk to exit insert mode by removing mapping for <esc>
inoremap <esc> <nop>
" Maps t to toggle char case then move back to it
nnoremap t ~h
nnoremap H 0
nnoremap L $

" Editor commands
nnoremap <leader>eq :qa!<cr>
nnoremap <leader>ew :w<cr>
nnoremap <leader>es :source %<cr>
nnoremap <leader>en :e $HOME/Documents/notes.md<cr>
nnoremap <leader>er :e $HOME/Documents/recipes/
nnoremap <leader>el :e $HOME/.vim/lookups.md<cr>
nnoremap <leader>ev :e $HOME/.vim/vimrc<cr>
nnoremap <leader>et :e $HOME/.vim/templates/template.
nnoremap <leader>ef :e $HOME/.vim/filetypes/
nnoremap <leader>eb :e $HOME/.bashrc<cr>
nnoremap <leader>em :e $HOME/.tmux.conf<cr>
nnoremap <leader>ep :exe 'e ' . getcwd() . '/project.vim'<cr>

" File related commands
nnoremap <leader>ff :fin 
nnoremap <leader>fe :e 
nnoremap <leader>fv :vsp 
nnoremap <leader>fl :Explore<cr>

" Buffer related commands
nnoremap <leader>bb :ls<cr>:b 
nnoremap <leader>bv :ls<cr>:vertical sb 
nnoremap <leader>bd :ls<cr>:bw 
nnoremap <leader>bl :b#<cr>
nnoremap <leader>bk :bw %<cr>
nnoremap <leader>br :2,bdelete<cr>

" Make related commands
nnoremap <leader>cm :silent make\|redraw!<cr>
nnoremap <leader>co :copen<cr>
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprevious<cr>
nnoremap <leader>cc :cclose<cr>

" Fugitive commands
nnoremap <leader>gs :Gstatus<cr>

" Window related commands
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Command bar remapping
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-d> <del>

" Journal commands
nnoremap <leader>jj :call OpenJournalToday()<cr>
nnoremap <leader>en :call OpenNote()<cr>

" Write related commands
cmap w!! w !sudo tee >/dev/null %

" Custom functions

" Retrieve the full file extension (all characters after the first dot), as
" opposed to Vim's interpretation (all chars after the last dot)
function! FullExtension(filename)
	return join(split(a:filename, '\.')[1:], '.')
endfunction

" Open a journal file for today's date
let s:secondsInDay = 60 * 60 * 24
function! OpenJournal()
	if !exists('s:currentDate')
		let s:currentDate = str2nr(system('date +%s'))
	endif
	let b:directory = $HOME . '/Documents/journal/'
	let b:journalfile = strftime('%Y%m%d', s:currentDate) . '.journal.md'
	if(!isdirectory(b:directory))
		call mkdir(b:directory, 'p')
	endif
	exe 'edit ' . b:directory . b:journalfile
	nnoremap <leader>jn :call OpenJournalTomorrow()<cr>
	nnoremap <leader>jp :call OpenJournalYesterday()<cr>
endfunction

function! OpenJournalToday()
	let s:currentDate = str2nr(system('date +%s'))
	call OpenJournal()
endfunction

function! OpenJournalTomorrow()
	let s:currentDate = s:currentDate + s:secondsInDay
	call OpenJournal()
endfunction

function! OpenJournalYesterday()
	let s:currentDate = s:currentDate - s:secondsInDay
	call OpenJournal()
endfunction

function! GetJournalDate(format)
	return strftime(a:format, s:currentDate)
endfunction

function! OpenNote()
	let b:noteName = input("Enter a name: ")
	let b:directory = $HOME . '/Documents/notes/'
	let b:notePath = b:directory . b:noteName . '.note.md'
	if(!isdirectory(b:directory))
		call mkdir(b:directory, 'p')
	endif
	exe 'edit ' . b:notePath
endfunction

" Custom autocommands
augroup vimrc
	autocmd!

	" Project specific config
	" Projects are configured through vim scripts in the project's root
	autocmd VimEnter * silent! exe 'source ' . getcwd() . '/project.vim'

	" Templating
	" Loads the contents of a template file if there is one, replacing all
	" characters between <<>> in the template with the result of executing those
	" contents within as a function in vim.
	" To add a template, place a template.<extension> file in the templates
	" directory in .vim.
	autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/template.' .  FullExtension(expand('<afile>:t'))
	autocmd BufNewFile * %substitute:<<\(.\{-}\)>>:\=eval(submatch(1)):ge

	" A replacement for the tempremental ftplugin system for loading filetype
	" specific config. Subfiletypes can also be customised, for example
	" .journal.md files load the config for .md then the config for .journal.md
	" (so overrides the more general config)
	autocmd BufNewFile,BufRead * silent! exe 'source ' $HOME . '/.vim/filetypes/' .  expand('<afile>:e') . '.vim'
	autocmd BufNewFile,BufRead * silent! exe 'source ' $HOME . '/.vim/filetypes/' .  FullExtension(expand('<afile>:t')) . '.vim'

	" Autosave buffers
	autocmd TextChanged,TextChangedI * silent! write
augroup END
