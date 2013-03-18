" Allow the ,w( key sequence to wrap the next symbol without leaving
" insert mode.
inoremap <silent> <buffer> ,O <Esc>w:<C-U>call PareditSplit()<CR>a
inoremap <silent> <buffer> ,J <Esc>w:<C-U>call PareditJoin()<CR>a
inoremap <silent> <buffer> ,S <Esc>w:<C-U>call PareditSplice()<CR>a
inoremap <silent> <buffer> ,W <Esc>w:<C-U>call PareditWrap("(",")")<CR>a
inoremap <silent> <buffer> ,w( <Esc>w:<C-U>call PareditWrap("(",")")<CR>a
inoremap <silent> <buffer> ,w[ <Esc>w:<C-U>call PareditWrap("[","]")<CR>a
inoremap <silent> <buffer> ,w{ <Esc>w:<C-U>call PareditWrap("{","}")<CR>a
inoremap <silent> <buffer> ,w" <Esc>w:<C-U>call PareditWrap('"','"')<CR>a
