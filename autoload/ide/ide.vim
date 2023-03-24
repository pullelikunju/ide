function! ide#ide#init()
  let g:ide.border=1
  let g:ide.columns=g:ide.explore+g:ide.workspaces*(g:ide.border+g:ide.numberwidth+g:ide.workspacewidth)
  let &columns=g:ide.columns
  let &colorcolumn=g:ide.workspacewidth+1
  let &laststatus=g:ide.laststatus
  let g:ide.lines=g:ide.workspaceheight+1
  if g:ide.buffertab ># 0
    let g:ide.lines+=g:ide.buffertab+1
  endif
  if g:ide.laststatus ># 0
    let g:ide.lines+=1
  endif
  let &lines=g:ide.lines
  if g:ide.numberwidth ># 0
    set relativenumber
    let &numberwidth=g:ide.numberwidth
  endif
  wincmd o
  let g:ide.win={'last':win_getid()}
  call ide#statusline#init()
  call ide#repo#init()
  call ide#explore#init()
  call ide#buffertab#init()
  call ide#workspace#init()
  wincmd b
  let l:i=1
  while l:i <# g:ide.workspaces
    wincmd b
    execute 'vertical '.(g:ide.workspacewidth+g:ide.numberwidth).'split'
    let l:i+=1
  endwhile
  call ide#explore#update()
  call ide#buffertab#update()
  noremap <silent> <MiddleMouse> <LeftMouse>:call ide#ide#handler('c')<CR>
  noremap <silent> <C-LeftMouse> <LeftMouse>:call ide#ide#handler('c')<CR>
  noremap <silent> <S-LeftMouse> <LeftMouse>:call ide#ide#handler('s')<CR>
  augroup IDEWinNr
    autocmd!
    autocmd WinLeave * call ide#ide#winlast()
  augroup END
endfunction
function! ide#ide#handler(mod)
  if win_getid() ==# g:ide.win.explore && a:mod ==? 'c'
    call ide#explore#chandler()
  elseif win_getid() ==# g:ide.win.explore && a:mod ==? 's'
    call ide#explore#shandler()
  elseif win_getid() ==# g:ide.win.buffertab && a:mod ==? 'c'
    call ide#buffertab#chandler()
  elseif win_getid() ==# g:ide.win.buffertab && a:mod ==? 's'
    call ide#buffertab#shandler()
  endif
endfunction
function! ide#ide#winlast()
  if(g:ide.win.explore !=# win_getid() && g:ide.win.buffertab !=# win_getid())
    let g:ide.win.last=win_getid()
  endif
endfunction
function! ide#ide#cwd()
  return tolower(getcwd())
endfunction
function! ide#ide#joinpath(dir, file)
  let l:sep=ide#ide#pathseparator()
  return trim(a:dir, l:sep, 2).l:sep.a:file
endfunction
function! ide#ide#pathseparator()
  let l:sep='/'
  if has('windows') ==# 1
    let l:sep='\'
  endif
  return l:sep
endfunction
function! ide#ide#relativepath(path)
  let l:cwd=ide#ide#cwd()
  let l:lwd=strlen(l:cwd)
  let l:rpath=a:path
  if a:path[0:lwd-1] ==? l:cwd
    let l:rpath=a:path[l:lwd+1:]
  endif
  return l:rpath
endfunction
