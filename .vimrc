" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set modelines=0

" undofile tells Vim to create <FILENAME>.un~ files whenever you edit a file. These files contain undo information so you can undo previous actions even after you close and reopen a file.
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#important-vimrc-lines
set undofile
set ttyfast
set scrolloff=3
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=500		" keep 500 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
"set ignorecase
"set smartcase
set autoindent
nnoremap <tab> %
vnoremap <tab> %

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

" Set encoding
set encoding=utf-8

" Toggle the ProjecDTreeToggleth \p
nmap <silent> <Leader>p :NERDTreeToggle<CR>

" CTags
"map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Handy tab controls
map <silent> tn :tabnew<CR>
map <silent> td :tabclose<CR>
map <silent> th :tabp<CR>
map <silent> tl :tabn<CR>

" Open a new tab with the current file, with a bit of a hack to allow it to
" work on files with modifications and not lose undo history because :tabnew %
" doesn't work correctly.
" map <silent> <Leader>n :tabnew<CR> :execute 'e #'<CR>

map <silent> <Leader>n :set relativenumber<CR>
map <silent> <Leader>N :set norelativenumber<CR>

" Jump back and forth between lines on the clist
map <silent> <Leader><Space> :cn <CR>
map <silent> <Leader><S-Space> :cp <CR>
map <silent> <Leader><C-Space> :cnf <CR>

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

" Select the block from the current location to the line with matching parens,
" delete all folds in the area and turn it into a single fold. Useful for
" wrongly folded javascript functions, etc.
nmap zZ v%zDgvzF

" Make a composite fold of selected folds except delete the first child fold
" I wanted this at one time for something...
vmap zZ zFzozdzc

" Don't use Ex mode, use Q for formatting
map Q gq

" Shift tab escapes from insert mode (now using S-Tab using for snippets)
" imap <S-Tab> <Esc>

" \F (capital F) activates folding on the file
map <silent> <Leader><C-f> <Plug>SimpleFold_Foldsearch

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif
if has("gui_running")
  "color slate
  color railscat
else
  color default
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

  " If the taglist window is open, close it and switch to the previously
  " active buffer when leaving the tab.
  autocmd TabLeave *
    \ if bufwinnr(g:TagList_title) != -1 |
      \ if bufwinnr(g:TagList_title) == bufwinnr('%') |
        \ exe bufwinnr('#') . 'wincmd w' |
      \ endif |
      \ exe 'TlistClose' |
    \ endif

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

let g:SimpleFold_use_subfolds = 0

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

map <C-l> <C-w>l
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k

" Below, I uncerimoniously copy stuff from
" git://github.com/jferris/config_files.git
"
" .... not doing so much rails anymore.

" Edit config/routes.rb
"map <Leader>R :e config/routes.rb<CR>
"map <Leader>E :e config/environment.rb<CR>
"map <Leader>S :e db/schema.rb<CR>
"map <Leader>F :e spec/factories.rb<CR>

" Leader shortcuts for Rails commands
"map <silent> <Leader>r :.Rake <CR>
"map <Leader>m :Rmodel <CR>
"map <Leader>c :Rcontroller <CR>
"map <Leader>v :Rview <CR>
"map <Leader>u :Runittest <CR>
"map <Leader>f :Rfunctionaltest <CR>
"map <Leader>i :Rintegrationtest<CR>
"map <Leader>tm :RTmodel <CR>
"map <Leader>tc :RTcontroller <CR>
"map <Leader>tv :RTview <CR>
"map <Leader>tu :RTunittest <CR>
"map <Leader>tf :RTfunctionaltest <CR>
"map <Leader>ti :Rintegrationtest<CR>
"map <Leader>sm :RSmodel <CR>
"map <Leader>sc :RScontroller <CR>
"map <Leader>sv :RSview <CR>
"map <Leader>su :RSunittest <CR>
"map <Leader>sf :RSfunctionaltest <CR>
"map <Leader>si :RSintegrationtest<CR>
"map <Leader>vm :RVmodel <CR>
"map <Leader>vc :RVcontroller <CR>
"map <Leader>vv :RVview <CR>
"map <Leader>vu :RVunittest <CR>
"map <Leader>vf :RVfunctionaltest <CR>
"map <Leader>vi :RVintegrationtest<CR>

" Use \a to open the taglist and jump to it, or jump to the previous buffer
" and close the tag list.
nmap <silent><expr> <Leader>a bufwinnr(g:TagList_title) == -1 ? ":TlistToggle<CR><C-w>p" : bufwinnr(g:TagList_title) == bufwinnr('%') ? "<C-w>p:TlistToggle<CR>" : ":TlistToggle<CR>"
" Configuration for the taglist.vim plugin
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Close_On_Select = 1
let Tlist_WinWidth = 60

" Hide search highlighting
map <silent> <Leader>h :set invhls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
" map <Leader>e :e <C-R>=expand("%:p:h") <CR>/

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
" map <Leader>te :tabe <C-R>=expand("%:p:h") <CR>/

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") <CR>/

" Delete the current buffer. Closes all views of the buffer and removes it
" from the buffer list
nmap <Leader>d :bd <CR>

" Quicker way to close a window.
nmap <Leader>q :q <CR>

" Delete the current file and close the buffer. This only works if the file is
" checked in to git and unmodified.
nmap <Leader><C-d> :!git rm %<CR>:bd<CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press p while in visual mode to replace the selection without
" overwriting the default register
vmap p p :call setreg('"', getreg('0')) <CR>

" Press gp while in visual mode to replace the selection without overwriting
" the default register and move the cursor to after the pasted text
vmap gp gp :call setreg('"', getreg('0')) <CR>

" Press P while in visual mode to get the original behaviour of p
vmap P "1ygv"0p :call setreg('"', getreg('1')) <CR>

" Display extra whitespace
set listchars=tab:»·,trail:·

if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif


" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc
set complete=.,t

" Key to echo the next function
let g:EchoFuncKeyNext = '<C-Space>'
" Key to echo the prev function
let g:EchoFuncKeyPrev = '<C-S-Space>'


" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" For dust templates
au BufNewFile,BufRead *.dust set filetype=html

function! s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function! s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

" From http://vimbits.com/bits?sort=top
map Y y$

" Adapted from http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

nmap <silent> <leader>= :call Preserve("normal gg=G")<CR>
nnoremap <silent> <leader>W :call Preserve("%s/\\s\\+$//e")<CR>
autocmd BufWritePre *.py,*.js,*.rb,*.coffee,*.clj,*.cljs :call Preserve("%s/\\s\\+$//e")

" Settings for VimClojure
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1

" Settings for Specky
" see :help specky
let g:speckyQuoteSwitcherKey = "<C-S>'"
let g:speckySpecSwitcherKey  = "<C-S>s"
let g:speckyRunSpecKey       = "<C-S>r"
let g:speckyWindowType       = 2
