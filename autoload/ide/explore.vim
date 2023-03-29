function! ide#explore#active(active)
  call win_execute(ide#prop#get('winexplore'), "match exploreactive '\\v%".0."l─[^$]+$'")
  let l:i=0
  while l:i <# len(ide#prop#get('exploremap'))
    if a:active ==? ide#prop#get('exploremap')[l:i][1]
      call win_execute(ide#prop#get('winexplore'), "match exploreactive '\\v%".(l:i+1).'l'.fnamemodify(a:active, ':t')."$'")
      let l:i=len(ide#prop#get('exploremap'))
    endif
    let l:i+=1
  endwhile
endfunction
function! ide#explore#handlerl()
  let l:sel=ide#explore#selection()
  if l:sel[0] ==? 'dir'
    if l:sel[1] ==? '..'
      call ide#explore#update()
      echo 'Folder Refreshed'
    elseif index(ide#prop#get('expand'), l:sel[1]) >=# 0
      call remove(ide#prop#get('expand'), index(ide#prop#get('expand'), l:sel[1]))
      let l:ll=line('w$')
      call ide#explore#update()
      execute 'normal! '.l:ll.'G'
    else
      call ide#prop#add('expand', l:sel[1])
      let l:ll=line('w$')
      call ide#explore#update()
      execute 'normal! '.l:ll.'G'
      if glob(ide#lib#joinpath(l:sel[1], '*')) ==# ''
        echo 'Opened empty folder'
      endif
    endif
    call win_gotoid(ide#prop#get('winlast'))
  else
    call ide#lib#win('last')
    execute 'edit '.l:sel[1]
  endif
endfunction
function! ide#explore#handlerm()
  let l:sel=ide#explore#selection()
  if l:sel[0] ==# 'dir'
    execute 'cd '.l:sel[1]
  elseif l:sel[0] ==# 'file'
    echo 'Opening in new tab . . .'
    silent execute 'tabnew '.l:sel[1]
  endif
  call ide#lib#win('last')
endfunction
function! ide#explore#handlers()
  let l:sel=ide#explore#selection()
  if l:sel[0] ==? 'dir'
    echo 'Opening folder . . .'
    silent execute '!start explorer '.l:sel[1]
  elseif l:sel[0] ==# 'file'
    echo 'Opening in default app . . .'
    silent execute '!start explorer '.l:sel[1]
  endif
  call ide#lib#win('last')
endfunction
function! ide#explore#init()
  call ide#lib#win('explore')
  execute 'e --ideexplore--'
  call ide#prop#set('expand', [])
  execute 'setlocal colorcolumn='.(ide#prop#get('explore')+1)
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal filetype=--ideexplore--
  setlocal matchpairs=
  setlocal nobuflisted
  setlocal nocursorline
  setlocal nolist
  setlocal nonumber
  setlocal norelativenumber
  setlocal noruler
  setlocal nospell
  setlocal noswapfile
  setlocal nowrap
  setlocal statusline=\ Repo:\ %{ide#prop#get('repostatus')}
  if has('nvim')
    setlocal winhighlight=Comment:Comment
  else
    setlocal wincolor=Comment
  endif
  setlocal winfixheight
  setlocal winfixwidth
  syntax match exploredirectory /≡[^$]*$/hs=s+1
  highlight link exploredirectory Directory
  syntax match explorefile /─[^$]*$/hs=s+1
  highlight link explorefile File
  highlight link exploreactive FileSel
  noremap <silent> <buffer> <LeftRelease> <LeftRelease>:call ide#explore#handlerl()<CR>
  call ide#lib#win('last')
endfunction
function! ide#explore#selection()
  let l:row=getmousepos().line
  return ide#prop#get('exploremap')[l:row-1]
endfunction
function! ide#explore#tree(dir, sp)
  let l:drs=[]
  let l:fls=[]
  let l:mfls=[]
  for l:name in readdir(a:dir, {n -> n !~ '.[^.]*.swp$'})
    let l:itm={'name': l:name, 'type': 'file'}
    let l:name=ide#lib#joinpath(a:dir, l:itm.name)
    if isdirectory(l:name)
      let l:itm.type='dir'
    endif
    if l:itm.type ==? 'dir'
      call ide#prop#add('exploremap', ['dir', l:name])
      call add(l:drs, a:sp.'└≡'.l:itm.name)
      if index(ide#prop#get('expand'), l:name) >=# 0
        let l:drs+=ide#explore#tree(l:name, a:sp.ide#prop#get('exploreindent'))
      endif
    else
      call add(l:mfls, ['file', l:name])
      call add(l:fls, a:sp.'└─'.l:itm.name)
    endif
  endfor
  for l:itm in l:mfls
    call ide#prop#add('exploremap', l:itm)
  endfor
  return (l:drs+l:fls)
endfunction
function! ide#explore#update()
  if(!empty(getbufline('--ideexplore--', 2)))
    silent call deletebufline('--ideexplore--', 1, '$')
  endif
  call ide#prop#set('exploremap', [['dir', '..']])
  call setbufline('--ideexplore--', 1, [ide#prop#get('exploreindent').'└≡..']+ide#explore#tree(ide#lib#cwd(), ide#prop#get('exploreindent')))
endfunction
