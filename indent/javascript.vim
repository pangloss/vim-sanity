" Vim indent file
" Language:		Javascript
" Maintainer:		Nikolai Weibull <now at bitwi.se>
" Info:			$Id: javascript.vim,v 1.47 2008/06/29 04:18:43 tpope Exp $
" URL:			http://vim-ruby.rubyforge.org
" Anon CVS:		See above site
" Release Coordinator:	Doug Kearns <dougkearns@gmail.com>

" 0. Initialization {{{1
" =================

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent

" Now, set up our indentation expression and keys that trigger it.
setlocal indentexpr=GetJavascriptIndent()
setlocal indentkeys=0{,0},0),0],!^F,o,O,e

" Only define the function once.
if exists("*GetJavascriptIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" 1. Variables {{{1
" ============

" Regex of syntax group names that are or delimit string or are comments.
let s:syng_strcom = '\<javascript\%(String\|StringEscape\|ASCIICode\|Interpolation\|NoInterpolation\|Comment\|Documentation\)\>'

" Regex of syntax group names that are strings.
let s:syng_string =
      \ '\<javascript\%(String\|Interpolation\|NoInterpolation\|StringEscape\)\>'

" Regex of syntax group names that are strings or documentation.
let s:syng_stringdoc =
  \'\<javascript\%(String\|Interpolation\|NoInterpolation\|StringEscape\|Documentation\)\>'

" Expression used to check whether we should skip a match with searchpair().
let s:skip_expr = "synIDattr(synID(line('.'),col('.'),1),'name') =~ '".s:syng_strcom."'"

let s:line_term = '\s*\%(\%(\/\/\).*\)\=$'

" Regex that defines continuation lines, not including (, {, or [.
let s:continuation_regex = '\%(\%([\\*+/.:]\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)\|\<\%(if\|else\|for\)\>[^{]*\)' . s:line_term

" Regex that defines continuation lines.
" TODO: this needs to deal with if ...: and so on
let s:continuation_regex2 = '\%(\%([\\*+/.:({[]\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)\)' . s:line_term


" Regex that defines blocks.
let s:block_regex =
      \ '\%({\)\s*\%(|\%([*@]\=\h\w*,\=\s*\)\%(,\s*[*@]\=\h\w*\)*|\)\=' . s:line_term

" 2. Auxiliary Functions {{{1
" ======================

" Check if the character at lnum:col is inside a string, comment, or is ascii.
function s:IsInStringOrComment(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~ s:syng_strcom
endfunction

" Check if the character at lnum:col is inside a string.
function s:IsInString(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~ s:syng_string
endfunction

" Check if the character at lnum:col is inside a string or documentation.
function s:IsInStringOrDocumentation(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~ s:syng_stringdoc
endfunction

" Find line above 'lnum' that isn't empty, in a comment, or in a string.
function s:PrevNonBlankNonString(lnum)
  let in_block = 0
  let lnum = prevnonblank(a:lnum)
  while lnum > 0
    " Go in and out of blocks comments as necessary.
    " If the line isn't empty (with opt. comment) or in a string, end search.
    let line = getline(lnum)
    if line =~ '/\*'
      if in_block
	let in_block = 0
      else
	break
      endif
    elseif !in_block && line =~ '\*/'
      let in_block = 1
    elseif !in_block && line !~ '^\s*\%(//\).*$' && !(s:IsInStringOrComment(lnum, 1) && s:IsInStringOrComment(lnum, strlen(line)))
      break
    endif
    let lnum = prevnonblank(lnum - 1)
  endwhile
  return lnum
endfunction

" Find line above 'lnum' that started the continuation 'lnum' may be part of.
function s:GetMSL(lnum)
  " Start on the line we're at and use its indent.
  let msl = a:lnum
  let lnum = s:PrevNonBlankNonString(a:lnum - 1)
  while lnum > 0
    " If we have a continuation line, or we're in a string, use line as MSL.
    " Otherwise, terminate search as we have found our MSL already.
    let line = getline(lnum)
    let col = match(line, s:continuation_regex2) + 1
    echom 'back to' lnum 'from' a:lnum ':' getline(lnum)
    echom '                     continuation regex 2 result:' col s:IsInStringOrComment(lnum, col) s:IsInString(lnum, strlen(line))
    if (col > 0 && !s:IsInStringOrComment(lnum, col)) || s:IsInString(lnum, strlen(line))
      echom '                     yes'
      let msl = lnum
    else
      echom '                     no'
      break
    endif
    let lnum = s:PrevNonBlankNonString(lnum - 1)
  endwhile
  return msl
endfunction

" Check if line 'lnum' has more opening brackets than closing ones.
function s:LineHasOpeningBrackets(lnum)
  let open_0 = 0
  let open_2 = 0
  let open_4 = 0
  let line = getline(a:lnum)
  let pos = match(line, '[][(){}]', 0)
  while pos != -1
    if !s:IsInStringOrComment(a:lnum, pos + 1)
      let idx = stridx('(){}[]', line[pos])
      if idx % 2 == 0
	let open_{idx} = open_{idx} + 1
      else
	let open_{idx - 1} = open_{idx - 1} - 1
      endif
    endif
    let pos = match(line, '[][(){}]', pos + 1)
  endwhile
  return (open_0 > 0) . (open_2 > 0) . (open_4 > 0)
endfunction

function s:Match(lnum, regex)
  let col = match(getline(a:lnum), a:regex) + 1
  return col > 0 && !s:IsInStringOrComment(a:lnum, col) ? col : 0
endfunction

function s:MatchLast(lnum, regex)
  let line = getline(a:lnum)
  let col = match(line, '.*\zs' . a:regex)
  while col != -1 && s:IsInStringOrComment(a:lnum, col)
    let line = strpart(line, 0, col)
    let col = match(line, '.*' . a:regex)
  endwhile
  return col + 1
endfunction

" 3. GetJavascriptIndent Function {{{1
" =========================

function GetJavascriptIndent()
  echom v:lnum '*********************************************************'
  " 3.1. Setup {{{2
  " ----------

  " Set up variables for restoring position in file.  Could use v:lnum here.
  let vcol = col('.')

  " 3.2. Work on the current line {{{2
  " -----------------------------

  " Get the current line.
  let line = getline(v:lnum)
  let ind = -1

  echom line

  " If we got a closing bracket on an empty line, find its match and indent
  " according to it.  For parentheses we indent to its column - 1, for the
  " others we indent to the containing line's MSL's level.  Return -1 if fail.
  let col = matchend(line, '^\s*[]})]')
  if col > 0 && !s:IsInStringOrComment(v:lnum, col)
    call cursor(v:lnum, col)
    let bs = strpart('(){}[]', stridx(')}]', line[col - 1]) * 2, 2)
    if searchpair(escape(bs[0], '\['), '', bs[1], 'bW', s:skip_expr) > 0
      if line[col-1]==')' && col('.') != col('$') - 1
        echom '                  closing bracket a'
        let ind = virtcol('.')-1
      else
        echom '                  closing bracket b'
        let ind = indent(s:GetMSL(line('.')))
      endif
    endif
    echom 'result' ind
    return ind
  endif

  " If we have a /* or */ set indent to first column.
  if match(line, '^\s*\%(/\*\|\*/\)$') != -1
    echom '                    in /* or */ '
    echom 'result 0'
    return 0
  endif

  " If we are in a multi-line string or line-comment, don't do anything to it.
  if s:IsInStringOrDocumentation(v:lnum, matchend(line, '^\s*') + 1)
    echom '                    in string or documentation'
    return indent('.')
  endif

  " 3.3. Work on the previous line. {{{2
  " -------------------------------

  " Find a non-blank, non-multi-line string line above the current line.
  let lnum = s:PrevNonBlankNonString(v:lnum - 1)

  " If the line is empty and inside a string, use the previous line.
  if line =~ '^\s*$' && lnum != prevnonblank(v:lnum - 1)
    return indent(prevnonblank(v:lnum))
  endif

  " At the start of the file use zero indent.
  if lnum == 0
    return 0
  endif

  " Set up variables for current line.
  let line = getline(lnum)
  let ind = indent(lnum)

  " If the previous line ended with a block opening, add a level of indent.
  if s:Match(lnum, s:block_regex)
    echom '             previous line had block opening'
    return indent(s:GetMSL(lnum)) + &sw
  endif

  " If the previous line contained an opening bracket, and we are still in it,
  " add indent depending on the bracket type.
  if line =~ '[[({]'
    let counts = s:LineHasOpeningBrackets(lnum)
    if counts[0] == '1' && searchpair('(', '', ')', 'bW', s:skip_expr) > 0
      if col('.') + 1 == col('$')
        echom '                     previous line had opening bracket a'
        echom 'result' ind + &sw
        return ind + &sw
      else
        echom '                     previous line had opening bracket b'
        echom 'result' virtcol('.')
        return virtcol('.')
      endif
    elseif counts[1] == '1' || counts[2] == '1'
      echom '                     previous line had opening bracket c'
      echom 'result' ind + &sw
      return ind + &sw
    else
      echom '                     previous line had opening bracket d (calling cursor method)'
      call cursor(v:lnum, vcol)
    end
  endif

  " 3.4. Work on the MSL line. {{{2
  " --------------------------

  " Set up variables to use and search for MSL to the previous line.
  let p_lnum = lnum
  let lnum = s:GetMSL(lnum)

  " If the previous line wasn't a MSL and is continuation return its indent.
  " TODO: the || s:IsInString() thing worries me a bit.
  if p_lnum != lnum
    if s:Match(p_lnum,s:continuation_regex)||s:IsInString(p_lnum,strlen(line))
      echom '                     no prev MSL but is continuation'
      echom 'result' ind
      return ind
    endif
  endif

  " Set up more variables, now that we know we wasn't continuation bound.
  let line = getline(lnum)
  let msl_ind = indent(lnum)


  echom getline(lnum)
  " If the previous line ended with [*+/.-=], indent one extra level.
  if s:Match(lnum, s:continuation_regex)
    echom '                   matched.'
    if lnum == p_lnum
      echom '                    extra level a'
      let ind = msl_ind + &sw
    else
      echom '                    extra level b'
      let ind = msl_ind
    endif
  endif

  " }}}2

  echom 'result' ind
  return ind
endfunction

" }}}1

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:

