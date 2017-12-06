setlocal expandtab
setlocal shiftwidth=2
if executable("php")
	setlocal makeprg=php\ \-l\ %
	setlocal errorformat=%m\ in\ %f\ on\ line\ %l
endif
