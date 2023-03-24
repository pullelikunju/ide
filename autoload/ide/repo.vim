function! ide#repo#init()
  let g:ide.repo={}
  call ide#repo#update()
endfunction
function! ide#repo#update()
  let l:stat='none'
  if isdirectory('.git')
    let l:stat='git'
    if filereadable(g:ide.bin.git)
      let l:stat.=' '.trim(system(g:ide.bin.git.' branch --show-current'))
      let l:exps=systemlist(g:ide.bin.git.' status --porcelain')
      let l:stat.=': '.len(l:exps)
    endif
  elseif isdirectory('.svn')
    let l:stat='svn'
    if filereadable(g:ide.bin.svn)
      let l:stat.=' '.trim(system(g:ide.bin.svn.' info --show-item revision'))
      let l:exps=systemlist(g:ide.bin.svn.' status')
      let l:stat.=': '.len(l:exps)
    endif
  endif
  let g:ide.repo.status=l:stat
endfunction
