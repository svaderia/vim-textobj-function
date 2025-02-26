" This is inspired from what's already there.
"
" Rather than relying on ][ or ]M we are search for the keywoard "fn"
" ][ would not work when the functions are inside `impl`
" ]M would not work when the functions are not inside `impl`
"
" So what we do is following:
"   1. backword search for keyword "fn"
"   2. go to the start of line, this takes care of "pub fn"
"   3. forward search for "{"
"   4. use "%" to go the the related "}"

function! textobj#function#rust#select(object_type)
  return s:select_{a:object_type}()
endfunction

function! s:select_a()
  " this takes care of the case when the cursor is on the line with `fn` but
  " before `fn`
  normal! $

  if search('fn\s\+', 'bW') == 0
    return 0
  endif

  normal! 0
  let l:startPos = getpos('.')

  if search('{', 'W') == 0
    return 0
  endif

  normal! %
  let l:endPos = getpos('.')

  if l:endPos[1] <= l:startPos[1]
    return 0
  endif

  return ['V', l:startPos, l:endPos]
endfunction

function! s:select_i()
  let l:range = s:select_a()

  " TODO: handle when s:select_a() returns 0.
  " I don't know how to compare if we got a list or 0. vim-noob

  let [_, l:startA, l:endA] = l:range

  call setpos('.', l:startA)

  if search('{', 'W') == 0
    return 0
  endif

  normal! j0
  let l:startI = getpos('.')

  call setpos('.', l:endA)

  normal! k$
  let l:endI = getpos('.')

  if l:endI[1] < l:startI[1]
    return 0
  endif

  return ['V', l:startI, l:endI]
endfunction
