function! ide#buffertab#handlerl()
  let l:sel=ide#buffertab#selection()
  call ide#lib#win('last')
  execute 'b'.l:sel[2]
endfunction
function! ide#buffertab#handlerm()
  let l:sel=ide#buffertab#selection()
  let l:wins=win_findbuf(l:sel[2])
  if len(wins) ==# 0
    noautocmd execute 'bd'.l:sel[2]
  else
    for l:win in l:wins
      noautocmd call win_gotoid(l:win)
      let l:name=bufname()
      if l:name !=? ''
        noautocmd execute 'enew'
      endif
    endfor
    if l:name !=? ''
      noautocmd execute 'bd'.l:sel[2]
    endif
  endif
  call ide#lib#win('last')
  call ide#buffertab#update()
endfunction
function! ide#buffertab#handlers()
  let l:sel=ide#buffertab#selection()
  call ide#lib#win('last')
  let l:exp=tolower(expand('#'.l:sel[2].':h'))
  while len(l:exp) ># len(ide#lib#cwd())
    if index(ide#prop#get('expand'), l:exp) <# 0
      call add(ide#prop#get('expand'), l:exp)
    endif
    let l:exp=fnamemodify(l:exp, ':h')
  endwhile
  call ide#explore#update()
  call ide#buffertab#update()
endfunction
function! ide#buffertab#init()
  call ide#lib#win('buffertab')
  execute 'e --idebuffertab--'
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal colorcolumn=0
  setlocal filetype=--idebuffertab--
  setlocal matchpairs=
  setlocal nobuflisted
  setlocal nocursorline
  setlocal nolist
  setlocal nonumber
  setlocal norelativenumber
  setlocal noruler
  setlocal nospell
  setlocal noswapfile
  setlocal statusline=%#Normal#%{ide#lib#cwd()}
  setlocal statusline+=%=
  setlocal statusline+=Workspace:\ %{ide#cmdws#cws()}\ 
  if has('nvim')
    setlocal winhighlight=TabLine:TabLine
  else
    setlocal wincolor=TabLine
  endif
  setlocal winfixheight
  setlocal wrap
  syntax match buffertabactive "\v\[[0-9]+:[^[]*]"
  highlight link buffertabactive TabLineFill
  syntax match buffertabloaded "\v\[[0-9]+¦[^[]*]"
  highlight link buffertabloaded TabLineSel
  inoremap <silent> <buffer> <LeftRelease> <Esc>:call ide#buffertab#handlerl()<CR>i
  noremap <silent> <buffer> <LeftRelease> <LeftRelease>:call ide#buffertab#handlerl()<CR>
  call ide#lib#win('last')
endfunction
function! ide#buffertab#selection()
  let l:col=getmousepos().column
  let l:i=0
  while l:i <# len(ide#prop#get('buffertabmap'))
    if l:col ># ide#prop#get('buffertabmap')[l:i][0] && l:col <=# ide#prop#get('buffertabmap')[l:i][1]
      return ide#prop#get('buffertabmap')[l:i]
    endif
    let l:i+=1
  endwhile
endfunction
function! ide#buffertab#update()
  call ide#prop#set('buffertabmap', [])
  let l:bufnr=bufnr('%')
  let l:bufs=''
  for l:buf in getbufinfo({'buflisted': 1})
    if len(l:bufs) ># 0
      let l:bufs.=ide#prop#get('buffertabseparator')
    endif
    let l:bt=len(l:bufs)
    let l:bufs.='['.l:buf.bufnr
    if l:buf.bufnr ==# l:bufnr
      let l:bufs.=':'
      call ide#explore#active(l:buf.name)
    elseif l:buf.loaded ==? 1
      let l:bufs.='¦'
    else
      let l:bufs.='|'
    endif
    if l:buf.name ==? ''
      let l:bufs.='No Name'
    else
      let l:bufs.=ide#lib#relativepath(l:buf.name)
    endif
    let l:bufs.=']'
    call ide#prop#add('buffertabmap', [l:bt, len(l:bufs), l:buf.bufnr])
  endfor
  if(!empty(getbufline('--idebuffertab--', 2)))
    silent call deletebufline('--idebuffertab--', 1, '$')
  endif
  let l:size=(1+len(l:bufs)/&columns)
  if ide#prop#get('buffertab') ># l:size
    let l:size=ide#prop#get('buffertab')
  endif
  call win_execute(ide#prop#get('winbuffertab'), 'resize '.l:size)
  call setbufline('--idebuffertab--', 1, l:bufs)
endfunction
