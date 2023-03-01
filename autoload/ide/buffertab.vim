function! ide#buffertab#init()
  if g:ide.buffertab ># 0
    set nosplitbelow
    topleft 1split --idebuffertab--
    let g:ide.win.buffertab=win_getid()
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal colorcolumn=0
    setlocal filetype=--idebuffertab--
    setlocal matchpairs=
    setlocal nobuflisted
    setlocal nocursorline
    setlocal list
    setlocal listchars=extends:»,precedes:«
    setlocal nonumber
    setlocal norelativenumber
    setlocal noruler
    setlocal nospell
    setlocal noswapfile
    setlocal statusline=%#Normal#%{ide#ide#cwd()}
    setlocal wincolor=TabLine
    setlocal winfixheight
    setlocal winfixwidth
    setlocal nowrap
    syntax match buffertabactive "\v\[[0-9]+:[^[]*]"
    highlight link buffertabactive TabLineSel
    syntax match buffertabloaded "\v\[[0-9]+¦[^[]*]"
    highlight link buffertabloaded TabLineFill
    noremap <silent> <buffer> <LeftRelease> <LeftRelease>:call ide#buffertab#handler()<CR>
    augroup IDEBuffertabUpdate
      autocmd!
      autocmd BufAdd     * call ide#buffertab#update()
      autocmd BufDelete  * call ide#buffertab#update()
      autocmd BufEnter   * call ide#buffertab#update()
      autocmd DirChanged * call ide#buffertab#update()
    augroup END
  endif
endfunction
function! ide#buffertab#update()
  let g:ide.buffertabmap=[]
  let l:bufnr=bufnr('%')
  let l:bufs=''
  for l:buf in getbufinfo({'buflisted': 1})
    let l:bt=len(l:bufs)
    let l:bufs.='['.l:buf.bufnr
    if l:buf.bufnr ==# l:bufnr
      let l:bufs.=':'
    elseif l:buf.loaded ==? 1
      let l:bufs.='¦'
    else
      let l:bufs.='|'
    endif
    if l:buf.name ==? ''
      let l:bufs.='No Name'
    else
      let l:bufs.=ide#ide#relativepath(l:buf.name)
    endif
    let l:bufs.=']'
    call add(g:ide.buffertabmap, [l:bt, len(l:bufs), l:buf.bufnr])
    let l:bufs.='  '
  endfor
  if(!empty(getbufline('--idebuffertab--', 2)))
    call deletebufline('--idebuffertab--', 1, '$')
  endif
  call setbufline('--idebuffertab--', 1, l:bufs)
endfunction
function! ide#buffertab#handler()
  let l:sel=ide#buffertab#selection()
  call win_gotoid(g:ide.win.last)
  execute 'b'.l:sel[2]
endfunction
function! ide#buffertab#chandler()
  let l:sel=ide#buffertab#selection()
  let l:wins=win_findbuf(l:sel[2])
  if len(wins) ==# 0
    execute 'bd'.l:sel[2]
  else
    for l:win in l:wins
      call win_gotoid(l:win)
      let l:name=bufname()
      if l:name !=? ''
        execute 'enew'
      endif
    endfor
    if l:name !=? ''
      execute 'bd'.l:sel[2]
    endif
  endif
  call win_gotoid(g:ide.win.last)
  call ide#buffertab#update()
endfunction
function! ide#buffertab#shandler()
  let l:sel=ide#buffertab#selection()
  call win_gotoid(g:ide.win.last)
  execute 'echo expand("#'.l:sel[2].':p")'
endfunction
function! ide#buffertab#selection()
  let l:col=getmousepos().column
  let l:i=0
  while l:i <# len(g:ide.buffertabmap)
    if l:col ># g:ide.buffertabmap[l:i][0] && l:col <=# g:ide.buffertabmap[l:i][1]
      return g:ide.buffertabmap[l:i]
    endif
    let l:i+=1
  endwhile
endfunction
