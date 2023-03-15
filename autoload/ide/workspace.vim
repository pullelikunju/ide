let s:wss={}
let s:cws=''
function! ide#workspace#init()
  if !empty(glob('~\.ide.vim'))
    let s:wss=json_decode(readfile(ide#ide#joinpath($HOME, '.ide.vim'))[0])
  endif
  augroup IDEWorkspaceSave
    autocmd!
    autocmd VimLeavePre * call ide#workspace#save()
  augroup END
endfunction
function! ide#workspace#cmd(ws)
  if a:ws ==? ''
    call ide#workspace#list()
  elseif exists('s:wss[a:ws]')
    if a:ws ==? s:cws
      call ide#workspace#del()
    else
      call ide#workspace#load(a:ws)
    endif
  else
    call ide#workspace#add(a:ws)
  endif
endfunction
function! ide#workspace#add(ws)
  call ide#workspace#update()
  let s:wss[a:ws]={'dir': ide#ide#cwd(), 'bufs': {}}
  let s:cws=a:ws
endfunction
function! ide#workspace#del()
  call remove(s:wss, s:cws)
  let s:cws=''
endfunction
function! ide#workspace#list()
  echo 'IDE()'
  if len(s:wss) <# 1
    echo '  Workspaces are not set'
  else
    let l:wss=keys(s:wss)
    for l:ws in l:wss
      let l:ln='  '
      if l:ws ==? s:cws
        let l:ln.='%'
      else
        let l:ln.=' '
      endif
      echo l:ln.l:ws.'  '.s:wss[l:ws]['dir']
    endfor
  endif
endfunction
function! ide#workspace#load(ws)
  execute 'cd '.s:wss[a:ws]['dir']
  for l:buf in keys(s:wss[a:ws]['bufs'])
    execute 'e +'.s:wss[a:ws]['bufs'][l:buf]['lnum'].' '.l:buf
  endfor
  let s:cws=a:ws
endfunction
function! ide#workspace#save()
  call ide#workspace#update()
  call writefile([json_encode(s:wss)], ide#ide#joinpath($HOME, '.ide.vim'))
endfunction
function! ide#workspace#update()
  if s:cws !=? ''
    let s:wss[s:cws]['bufs']={}
    for l:buf in getbufinfo({'buflisted': 1})
      if l:buf.name !=? ''
        let s:wss[s:cws]['bufs'][l:buf.name]={'lnum': l:buf.lnum}
      endif
    endfor
  endif
endfunction
