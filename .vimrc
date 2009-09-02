" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set nobackup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ai

"set number
set nowrap
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
set virtualedit=onemore
"set virtualedit=all
set vb t_vb=
set wildmenu
set path=.,**

set viminfo='50,<1000,s100,:1000,n~/.vim/viminfo
set hid

"map <silent> <F3> :call BufferList()<CR>
"map <silent> <F4> :TlistToggle<CR>
"nmap <silent> <F2> <Plug>ToggleProject

" Toggle the Project plugin with \p
nmap <silent> <Leader>p <Plug>ToggleProject

" Handy tab controls
map tn :tabnew<CR>
map <silent> <Leader>n :tabnew #<CR>
map td :tabclose<CR>
map th :tabp<CR>
map tl :tabn<CR>

" Arrange a window with 4 buffers in any configuration into a 2x2 grid.
" steps: arrange in one column, move 1 buffer to the right column,
"   switch to the top of the left column and mark the buffer, switch back to
"   the right column, split the buffer and jump to the marked buffer. Delete
"   the mark. Rotate the right pane to put the buffers back into their
"   original order. Switch back to the copy of the marked buffer in the first
"   column and close the extra copy of that buffer. 
"
" With different number of buffers, it usually results in the right column
" having 2 buffers and the left column with the rest of them.
nmap <silent> <Leader>4 <C-W>J<C-W>w<C-W>J<C-W>w<C-W>L<C-W>hmM<C-W>l<C-W>s'M:delm M<CR><C-W>r<C-W>w<C-W>q

" Make a composite fold of selected folds except delete the first child fold
" I wanted this at one time for something...
vmap zZ zFzozdzc

"map <leader>t :TlistToggle<CR>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq


" Shift tab escapes from insert mode (now using S-Tab using for snippets)
" imap <S-Tab> <Esc>
 
" \F (capital F) activates folding on the file
map <silent> <Leader>F <Plug>SimpleFold_Foldsearch



" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

color slate

" Up/down key behaviour {{{1
" -- Changes up/down arrow keys to behave screen-wise, rather than file-wise.
"    Behaviour is unchanged in operator-pending mode.
"    Behaviour is unchanged for the j and k bindings.

" Extra-elaborate to stop remapping from interfering with Omni-complete popup
inoremap <silent><expr><Up> pumvisible() ? "<Up>" : "<C-O>gk"
inoremap <silent><expr><Down> pumvisible() ? "<Down>" : "<C-O>gj"

" Treat wrapped text the way any other text editor would
nnoremap <silent>k gk
nnoremap <silent>j gj
nnoremap <silent><Up> gk
nnoremap <silent><Down> gj
vnoremap <silent>k gk
vnoremap <silent>j gj
vnoremap <silent><Up> gk
vnoremap <silent><Down> gj


" Below, I uncerimoniously copy stuff from
" git://github.com/jferris/config_files.git

" Edit the README_FOR_APP (makes :R commands work)
map <Leader>R :e doc/README_FOR_APP<CR>

" Leader shortcuts for Rails commands
map <Leader>m :Rmodel <CR>
map <Leader>c :Rcontroller <CR>
map <Leader>v :Rview <CR>
map <Leader>u :Runittest <CR>
map <Leader>f :Rfunctionaltest <CR>
map <Leader>i :Rintegrationtest<CR>
map <Leader>tm :RTmodel <CR>
map <Leader>tc :RTcontroller <CR>
map <Leader>tv :RTview <CR>
map <Leader>tu :RTunittest <CR>
map <Leader>tf :RTfunctionaltest <CR>
map <Leader>ti :Rintegrationtest<CR>
map <Leader>sm :RSmodel <CR>
map <Leader>sc :RScontroller <CR>
map <Leader>sv :RSview <CR>
map <Leader>su :RSunittest <CR>
map <Leader>sf :RSfunctionaltest <CR>
map <Leader>si :RSintegrationtest<CR>
map <Leader>vm :RVmodel <CR>
map <Leader>vc :RVcontroller <CR>
map <Leader>vv :RVview <CR>
map <Leader>vu :RVunittest <CR>
map <Leader>vf :RVfunctionaltest <CR>
map <Leader>vi :RVintegrationtest<CR>

" Hide search highlighting
map <Leader>h :set invhls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") <CR>/

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") <CR>/

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") <CR>/

" Maps autocomplete to Ctrl-Space
imap <C-Space> <C-N>

nmap <Leader>d :bd <CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press p while in visual mode to replace the selection without
" overwriting the default register
vmap p p :call setreg('"', getreg('0')) <CR>

vmap gp gp :call setreg('"', getreg('0')) <CR>

" Press P in visual mode to get the original behaviour of p
vmap P "1ygv"0p :call setreg('"', getreg('1')) <CR>

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

