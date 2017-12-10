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
set hidden " allows 'abandoning' a buffer without saving
set incsearch
set tabstop=2
set shiftwidth=2
set laststatus=2
set statusline=%<%f\ %y%{fugitive#statusline()}%q%=\ %10(%3l,%02c%)
set noswapfile
set sessionoptions=" options,windows,localoptions,help,buffers"
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

" Editor commands
nnoremap <leader>eq :qa!<cr>
nnoremap <leader>ew :w<cr>
nnoremap <leader>es :source $MYVIMRC<cr>
nnoremap <leader>el :e ~/.vim/lookups.md<cr>
nnoremap <leader>en :e ~/Documents/notes.md<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>eh :h 
nnoremap <leader>ej :call OpenJournal()<cr> 

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
nnoremap <leader>cs :silent make\ start\|redraw!<cr>
nnoremap <leader>co :copen<cr>
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprevious<cr>
nnoremap <leader>cc :cclose<cr>

nnoremap <leader>ds :!vagrant up<cr>
nnoremap <leader>de :!vagrant halt<cr>

" Window related commands
nnoremap <leader>ws :split<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Journal commands
command! Jtoday call OpenJournalToday()
command! Jnext call OpenJournalTomorrow()
command! Jprev call OpenJournalYesterday()

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

" Opens a new buffer that has no filetype and closes without warning messages
" Can specify the buffer name as first param and whether to clear when opening
function! OpenAppBuffer(...)
	let l:bufferName = a:1
	exe 'silent! vsplit ' . l:bufferName
	setlocal buftype=nofile
	setlocal bufhidden=hide
endfunction

let s:personAccessToken = '0/cf732e275e31b7cb1138ae5246a0c7d5'
let s:workspaces = []
let s:workspaceId = ''
let s:tasks = []
let s:taskId = ''
let s:task = {}

command! AOpen call RefreshAsanaWorkspaces()<cr> 

function! RefreshAsanaWorkspaces()
	let l:command = 'curl -s -H "Authorization: Bearer ' . s:personAccessToken . '" https://app.asana.com/api/1.0/workspaces'
	let s:workspaces = ParseJSON(system(l:command))['data']
	call ShowAsanaWorkspaces()
endfunction

function! ShowAsanaWorkspaces()
	silent! exe 'bw ' . 'ASANA_BUFFER'
	call OpenAppBuffer('ASANA_BUFFER')
	if len(s:workspaces) < 1
		call append(0, 'No workspaces found')
	endif
	for workspace in s:workspaces
		call append(0, printf("%-18s%-1s", workspace['id'], workspace['name']))
	endfor
	let l:workspaceLine = 1
	if exists("s:workspaceId")
		let l:searchWorkspaceLine = search(s:workspaceId)
		if l:searchWorkspaceLine > 0
			let l:workspaceLine = l:searchWorkspaceLine
		endif
	endif
	call cursor(l:workspaceLine, 1)
	setlocal nomodifiable	
	nnoremap <buffer> <cr> :call GetAsanaWorkspaceFromLine()<cr>
	nnoremap <buffer> R :call RefreshAsanaWorkSpaces()<cr>
endfunction()

function! GetAsanaWorkspaceFromLine()
	let s:workspaceId = s:workspaces[line("*")]['id']
	call RefreshAsanaWorkspaceTasks()
endfunction

function! RefreshAsanaWorkspaceTasks()
	set maxfuncdepth=10000
	let l:command = 'curl -s -H "Authorization: Bearer ' . s:personAccessToken . '" https://app.asana.com/api/1.0/tasks?\workspace=' . s:workspaceId . '\&assignee=me\&opt_fields=completed,name'
	let s:tasks = ParseJSON(system(l:command))['data']
	set maxfuncdepth=100
	call ShowAsanaWorkspaceTasks()
endfunction

let s:filterIncomplete = 0
function! ShowAsanaWorkspaceTasks(...)
	let l:tasks = copy(s:tasks)
	if s:filterIncomplete
		let temp = []
		for task in l:tasks
			if !task['completed']
				call add(temp, task)
			endif
		endfor
		let l:tasks = temp
	endif
	silent! exe 'bw ' . 'ASANA_BUFFER'
	call OpenAppBuffer('ASANA_BUFFER')
	if len(l:tasks) < 1
		call append(0, 'No tasks found')
	endif
	for task in l:tasks
		call append(0, printf("%-1s", task['name']))
	endfor
	setlocal nomodifiable	
	nnoremap <buffer> q :call ShowAsanaWorkspaces()<cr>
	nnoremap <buffer> <cr> :call OpenAsanaTask()<cr>
	nnoremap <buffer> R :call RefreshAsanaWorkspaceTasks()<cr>
	nnoremap <buffer> fi :call ToggleFilterAsanaTasksIncomplete()<cr>
	let l:taskLine = 1
	if exists("s:taskId")
		let l:searchTaskLine = search(s:taskId)
		if l:searchTaskLine > 0
			let l:taskLine = l:searchTaskLine
		endif
	endif
	call cursor(l:taskLine, 1)
endfunction

function! ToggleFilterAsanaTasksIncomplete()
	let s:filterIncomplete = !s:filterIncomplete
	call ShowAsanaWorkspaceTasks()
endfunction

function! OpenAsanaTask()
	let s:taskId = s:tasks[line("*")]['id']
	call RefreshAsanaTask()
endfunction

function! DeleteAsanaTask()
	let l:taskId = s:tasks[line("*")]['id']
	let l:choice = confirm("Really delete task " . l:taskId . "?")
	if l:choice == 1
		let l:command = 'curl -s -X DELETE -H "Authorization: Bearer ' . s:personAccessToken . '" https://app.asana.com/api/1.0/tasks/' . l:taskId
		call system(l:command)
		unlet s:tasks[l:taskId]
		call ShowAsanaWorkspaceTasks()
	endif
endfunction

function! RefreshAsanaTask()
	let l:command = 'curl -s -H "Authorization: Bearer ' . s:personAccessToken . '" https://app.asana.com/api/1.0/tasks/' . s:taskId
	let s:task = ParseJSON(system(l:command))['data']
	call ShowAsanaTask()
endfunction

function! ShowAsanaTask()
	silent! exe 'bw ' . 'ASANA_BUFFER'
	call OpenAppBuffer('ASANA_BUFFER')
	setlocal wrap
	setlocal textwidth=79
	call append(0, iconv(s:task['notes'], "utf-16", &encoding))
	call append(0, 'Description')
	call append(0, s:task['completed'])
	call append(0, s:task['id'] . ' ' . s:task['name'])
	setlocal nomodifiable	
	nnoremap <buffer> q :call ShowAsanaWorkspaceTasks()<cr>
	nnoremap <buffer> R :call RefreshAsanaTask()<cr>
endfunction

" Custom autocommands
augroup vimrc
	autocmd!

	" Project specific config
	" Projects are configured through vim scripts in the project's directory
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
	" specific config. Different types of settings with a filetype can also be
	" customised, for example .journal.md files load the config for .md then the
	" config for .journal.md (so overrides the more general config)
	autocmd BufNewFile,BufRead * silent! exe 'source ' $HOME . '/.vim/filetypes/' .  expand('<afile>:e') . '.vim'
	autocmd BufNewFile,BufRead * silent! exe 'source ' $HOME . '/.vim/filetypes/' .  FullExtension(expand('<afile>:t')) . '.vim'
augroup END
