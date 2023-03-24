function! ide#repo#init()
  call ide#repo#update()
endfunction
function! ide#repo#update()
  if isdirectory('.git')
    if filereadable(g:ide.repo.git)
      let l:stat=systemlist(g:ide.repo.git.' status --porcelain')
      let g:ide.repo.status='git '.len(l:stat)
    else
      let g:ide.repo.status='git'
    endif
  elseif isdirectory('.svn')
    if filereadable(g:ide.repo.svn)
      let l:stat=systemlist(g:ide.repo.svn.' status')
      let g:ide.repo.status='svn '.len(l:stat)
    else
      let g:ide.repo.status='svn'
    endif
  else
    let g:ide.repo.status='none'
  endif
endfunction
