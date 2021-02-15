nnoremap <buffer> o :call <SID>NextItem(1)<cr>
nnoremap <buffer> O :call <SID>NextItem(0)<cr>

let s:pattern = '\v^\[\d+\]'
let s:numPattern = '\v\d+'

function! s:NextItem(isBelowCursor)
  let key = "o"
  if getline(".") =~ s:pattern
    let currentIndex = matchstr(getline("."), s:numPattern)
    if a:isBelowCursor
      let requiredIndex = currentIndex + 1
      let key = "o"
      call ChangeListIndexes(line(".") + 1, requiredIndex)
    else 
      let requiredIndex = currentIndex
      let key = "O"
      call ChangeListIndexes(line("."), requiredIndex)
    endif

    execute "normal! " . key . "[" . requiredIndex . "] "
    startinsert!
  else
    if !a:isBelowCursor
      let key = "O"
    endif
    execute "normal! " . key
  endif
endfunction

function! ChangeListIndexes(lnum, index)
  let count = a:index
  let currentLineNumber = a:lnum
  let lastline = line('$')
  while currentLineNumber <= lastline
    if getline(currentLineNumber) =~ s:pattern
      let count = count + 1
      let text = substitute(getline(currentLineNumber), s:numPattern, count, "")
      call setline(currentLineNumber, text)
    endif
    let currentLineNumber = currentLineNumber + 1
  endwhile
endfunction
