let s:wss={}
let s:cws=''
function! ide#cmdws#init()
  if !empty(glob('~\.ide.vim'))
    let s:wss=json_decode(readfile(ide#lib#joinpath($HOME, '.ide.vim'))[0])
  endif
endfunction
function! ide#cmdws#add(ws)
  call ide#cmdws#update()
  let s:wss[a:ws]={'dir': ide#lib#cwd(), 'bufs': {}}
  let s:cws=a:ws
endfunction
function! ide#cmdws#cmd(ws)
  if a:ws ==? ''
    call ide#cmdws#list()
  elseif exists('s:wss[a:ws]')
    if a:ws ==? s:cws
      call ide#cmdws#del()
    else
      call ide#cmdws#load(a:ws)
    endif
  else
    call ide#cmdws#add(a:ws)
  endif
endfunction
function! ide#cmdws#cws()
  if s:cws ==? ''
    return 'none'
  else
    return s:cws 
  endif
endfunction
function! ide#cmdws#del()
  call remove(s:wss, s:cws)
  let s:cws=''
endfunction
function! ide#cmdws#list()
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
function! ide#cmdws#load(ws)
  call ide#cmdws#update()
  execute 'cd '.s:wss[a:ws]['dir']
  for l:buf in s:wss[a:ws]['bufs']
    execute 'edit +'.l:buf.lnum.' '.l:buf.name
  endfor
  for l:buf in s:wss[a:ws]['bufs']
    if exists('l:buf.windows') && len(l:buf.windows) ># 0
      for l:win in l:buf.windows
        call ide#lib#win(l:win[3:])
        execute 'edit +'.l:buf.lnum.' '.l:buf.name
      endfor
    endif
  endfor
  let s:cws=a:ws
  call ide#lib#win('ws1')
  call ide#buffertab#update()
endfunction
function! ide#cmdws#save()
  call ide#cmdws#update()
  call writefile([json_encode(s:wss)], ide#lib#joinpath($HOME, '.ide.vim'))
endfunction
function! ide#cmdws#update()
  if s:cws !=? ''
    let s:wss[s:cws]['bufs']=[]
    for l:buf in getbufinfo({'buflisted': 1})
      if l:buf.name !=? ''
        let l:prop={'lnum': l:buf.lnum, 'name': l:buf.name}
        if len(l:buf.windows) ># 0
          let l:winws=ide#prop#winws()
          let l:winkeys=keys(l:winws)
          let l:winvals=values(l:winws)
          let l:prop.windows=[]
          for l:win in l:buf.windows
            let l:i=index(l:winvals, l:win)
            if l:i >=# 0
              let l:prop.windows+=[l:winkeys[l:i]]
            endif
          endfor
        endif
        let s:wss[s:cws]['bufs']+=[l:prop]
      endif
    endfor
  endif
endfunction
