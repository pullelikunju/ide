function! ide#lib#cwd()
  return tolower(getcwd())
endfunction
function! ide#lib#handler(mod)
  if win_getid() ==# ide#prop#get('winexplore')
    if a:mod ==? 'm'
      call ide#explore#handlerm()
    elseif a:mod ==? 's'
      call ide#explore#handlers()
    endif
  elseif win_getid() ==# ide#prop#get('winbuffertab')
    if a:mod ==? 'm'
      call ide#buffertab#handlerm()
    elseif a:mod ==? 's'
      call ide#buffertab#handlers()
    endif
  endif
endfunction
function! ide#lib#init()
  if ide#prop#get('workspaces') <# 1
    call ide#prop#set('workspaces', 1)
  endif
  call ide#prop#set('border', 1)
  call ide#prop#set('columns', ide#prop#get('explore')+ide#prop#get('workspaces')*(ide#prop#get('border')+ide#prop#get('numberwidth')+ide#prop#get('workspacewidth')))
  call ide#prop#set('lines', ide#prop#get('workspaceheight')+1)
  execute 'set laststatus='.ide#prop#get('laststatus')
  call ide#lib#layout()
  call ide#repo#init()
  call ide#explore#update()
  call ide#buffertab#update()
  call ide#cmdws#init()
  noremap <silent> <MiddleMouse>   <LeftMouse>:call ide#lib#handler('m')<CR>
  noremap <silent> <C-LeftMouse>   <LeftMouse>:call ide#lib#handler('m')<CR>
  noremap <silent> <S-LeftMouse>   <LeftMouse>:call ide#lib#handler('s')<CR>
  augroup IDEAutoCmd
    autocmd!
    autocmd BufAdd      * call ide#buffertab#update()
    autocmd BufDelete   * call ide#buffertab#update()
    autocmd BufEnter    * call ide#buffertab#update()
    autocmd DirChanged  * call ide#buffertab#update()
    autocmd DirChanged  * call ide#repo#update()
    autocmd DirChanged  * call ide#explore#update()
    autocmd VimLeavePre * call ide#cmdws#save()
    autocmd WinLeave    * call ide#lib#winlast()
  augroup END
endfunction
function! ide#lib#joinpath(dir, file)
  let l:sep=ide#lib#pathseparator()
  return trim(a:dir, l:sep, 2).l:sep.a:file
endfunction
function! ide#lib#layout()
  execute 'set columns='.ide#prop#get('columns')
  execute 'set lines='.ide#prop#get('lines')
  if ide#prop#get('buffertab') ># 0
    call ide#prop#set('winbuffertab', win_getid())
    set splitbelow
    execute (ide#prop#get('lines')-1)'split'
    call ide#buffertab#init()
  endif
  if ide#prop#get('explore') ># 0
    call ide#prop#set('winexplore', win_getid())
    set splitright
    execute 'vertical '.(ide#prop#get('workspaces')*(ide#prop#get('border')+ide#prop#get('numberwidth')+ide#prop#get('workspacewidth'))-1).'split'
    call ide#explore#init()
  endif
  if ide#prop#get('terminal') ># 0
    call ide#prop#set('winws1', win_getid())
    set splitbelow
    execute (ide#prop#get('terminal')-1)'split'
    call ide#prop#set('winterminal', win_getid())
    call ide#terminal#init()
    call ide#lib#win('ws1')
  endif
  let l:ws=1
  while l:ws <# ide#prop#get('workspaces')
    call ide#prop#set('winws'.l:ws, win_getid())
    set splitright
    execute 'vertical '.(ide#prop#get('workspacewidth')+ide#prop#get('numberwidth')).'split'
    call ide#workspace#init(l:ws)
    let l:ws+=1
  endwhile
  call ide#prop#set('winws'.l:ws, win_getid())
  call ide#workspace#init(l:ws)
  call ide#lib#win('ws1')
endfunction
function! ide#lib#pathseparator()
  let l:sep='\'
  if has('unix') ==# 1
    let l:sep='/'
  endif
  return l:sep
endfunction
function! ide#lib#relativepath(path)
  let l:cwd=ide#lib#cwd()
  let l:lwd=strlen(l:cwd)
  let l:rpath=a:path
  if a:path[0:lwd-1] ==? l:cwd
    let l:rpath=a:path[l:lwd+1:]
  endif
  return l:rpath
endfunction
function! ide#lib#win(win)
  if a:win !=? 'last'
    call ide#prop#set('winlast', win_getid())
  endif
  noautocmd call win_gotoid(ide#prop#get('win'.a:win))
endfunction
function! ide#lib#winlast()
  if index(values(ide#prop#winws()), win_getid()) >=# 0
    call ide#prop#set('winlast', win_getid())
  endif
endfunction
