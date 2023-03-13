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
  let s:wss[a:ws]={'dir': ide#ide#cwd()}
  let s:cws=a:ws
call ide#workspace#save()
endfunction
function! ide#workspace#del()
  call remove(s:wss, s:cws)
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
  let s:cws=a:ws
endfunction
function! ide#workspace#save()
  call writefile([json_encode(s:wss)], ide#ide#joinpath($HOME, '.ide.vim'))
endfunction
