" Allow the ,w( key sequence to wrap the next symbol without leaving
" insert mode.
inoremap <silent> <buffer> ,w( <Esc>w:<C-U>call PareditWrap("(",")")<CR>a
inoremap <silent> <buffer> ,w[ <Esc>w:<C-U>call PareditWrap("[","]")<CR>a
inoremap <silent> <buffer> ,w{ <Esc>w:<C-U>call PareditWrap("{","}")<CR>a
inoremap <silent> <buffer> ,w" <Esc>w:<C-U>call PareditWrap('"','"')<CR>a
