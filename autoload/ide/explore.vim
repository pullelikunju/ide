function! ide#explore#init()
  if g:ide.explore ># 0
    let g:ide.expand=[]
    set nosplitright
    topleft vertical 30split --ideexplore--
    let g:ide.win.explore=win_getid()
    execute 'setlocal colorcolumn='.(g:ide.explore+1)
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal filetype=--ideexplore--
    setlocal nobuflisted
    setlocal nocursorline
    setlocal list
    setlocal listchars=extends:»,precedes:«
"setlocal nomodifiable
    setlocal nonumber
    setlocal norelativenumber
    setlocal noruler
    setlocal nospell
    setlocal noswapfile
    setlocal nowrap
    setlocal statusline=\ 
    setlocal winfixheight
    setlocal winfixwidth
    syntax keyword exploresymbol └
    highlight link exploresymbol Comment
    syntax match exploredirectory "\v≡[^$]*$"
    highlight link exploredirectory Directory
    syntax match explorefile "\v─[^$]*$"
    highlight link explorefile File
    noremap <silent> <buffer> <LeftRelease> <LeftRelease>:call ide#explore#handler()<CR>
    augroup IDEExploreUpdate
      autocmd!
      autocmd DirChanged  * call ide#explore#update()
    augroup END
  endif
endfunction
function! ide#explore#update()
  if(!empty(getbufline('--ideexplore--', 2)))
    call deletebufline('--ideexplore--', 1, '$')
    echo ''
  endif
  let g:ide.exploremap=[['dir', '..']]
  call setbufline('--ideexplore--', 1, [g:ide.exploreindent.'└≡..']+ide#explore#tree(ide#ide#cwd(), g:ide.exploreindent))
endfunction
function! ide#explore#tree(dir, sp)
"  let l:mdrs=[]
  let l:drs=[]
  let l:fls=[]
  let l:mfls=[]
  for l:itm in readdirex(a:dir, {e -> e.name !~ '.[^.]*.swp$'}, #{sort: 'icase'})
    let l:name=ide#ide#joinpath(a:dir, l:itm.name)
    if l:itm.type ==? 'dir'
"      call add(l:mdrs, ['dir', l:name])
      call add(g:ide.exploremap, ['dir', l:name])
      call add(l:drs, a:sp.'└≡'.l:itm.name)
      if(index(g:ide.expand, l:name) >=0 )
        let l:drs+=ide#explore#tree(l:name, a:sp.g:ide.exploreindent)
      endif
    else
      call add(l:mfls, ['file', l:name])
      call add(l:fls, a:sp.'└─'.l:itm.name)
    endif
  endfor
  for l:itm in l:mfls
    call add(g:ide.exploremap, l:itm)
  endfor
  return (l:drs+l:fls)
endfunction
function! ide#explore#handler()
  let l:sel=ide#explore#selection()
  call win_gotoid(g:ide.win.last)
  if l:sel[0] ==? 'dir'
    if index(g:ide.expand, l:sel[1]) >=# 0
      call remove(g:ide.expand, index(g:ide.expand, l:sel[1]))
      call ide#explore#update()
    else
      call add(g:ide.expand, l:sel[1])
      call ide#explore#update()
    endif
  else
    execute 'edit '.l:sel[1]
  endif
endfunction
function! ide#explore#chandler()
  execute 'cd '.ide#explore#selection()[1]
  call win_gotoid(g:ide.win.last)
endfunction
function! ide#explore#shandler()
  let l:sel=ide#explore#selection()
  if l:sel[0] ==? 'dir'
    silent execute '!start explorer '.l:sel[1]
  else
    execute 'tabnew '.l:sel[1]
  endif
  call win_gotoid(g:ide.win.last)
endfunction
function! ide#explore#selection()
  let l:row=getmousepos().line
  return g:ide.exploremap[l:row-1]
endfunction