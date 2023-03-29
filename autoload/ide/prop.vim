function! ide#prop#add(key, val)
  call add(s:prop[a:key], a:val)
endfunction
function! ide#prop#get(key)
  return s:prop[a:key]
endfunction
function! ide#prop#init()
  if exists('s:prop')
    return 0
  endif
  let s:prop={}
  return 1
endfunction
function! ide#prop#set(key, val)
  let s:prop[a:key]=a:val
endfunction
function! ide#prop#winws()
  let l:winws={}
  let l:i=1
  for l:key in keys(s:prop)
    if l:key[0:4] ==? 'winws'
      let l:winws[l:key]=s:prop[l:key]
    endif
  endfor
  return l:winws
endfunction
function! ide#prop#wswin()
  let l:winws=ide#prop#winws()
  let l:wswin={}
  for l:key in keys(l:winws)
    let l:wswin[l:winws[l:key]]=l:key
  endfor
  return wswin
endfunction
