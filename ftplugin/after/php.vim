setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l,%-GErrors\ parsing\ %f,%-G
nnoremap <f5> :update<bar>make<bar>cwindow<cr>
