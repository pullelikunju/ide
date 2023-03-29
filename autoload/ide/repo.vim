function! ide#repo#init()
  call ide#repo#update()
endfunction
function! ide#repo#update()
  let l:stat='none'
  if isdirectory('.git')
    let l:stat='git'
    if filereadable(ide#prop#get('git'))
      let l:stat.=' '.trim(system(ide#prop#get('git').' branch --show-current'))
      let l:exps=systemlist(ide#prop#get('git').' status --porcelain')
      let l:stat.=': '.len(l:exps)
    endif
  elseif isdirectory('.svn')
    let l:stat='svn'
    if filereadable(ide#prop#get('svn'))
      let l:stat.=' '.trim(system(ide#prop#get('svn').' info --show-item revision'))
      let l:exps=systemlist(ide#prop#get('svn').' status')
      let l:stat.=': '.len(l:exps)
    endif
  endif
  call ide#prop#set('repostatus', l:stat)
endfunction
