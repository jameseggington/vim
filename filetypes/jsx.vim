setlocal expandtab
setlocal shiftwidth=2
if executable("jshint")
	setlocal makeprg=jshint\ %
	setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
endif

" Auto insert closing brackets
inoremap {{ {<cr>}<esc>O
