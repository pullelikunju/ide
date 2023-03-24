function! ide#repo#init()
  augroup IDERepoUpdate
    autocmd!
    autocmd DirChanged * call ide#repo#update()
  augroup END
endfunction
function! ide#repo#update()
  if isdirectory('.git')
    let l:stat=systemlist(g:ide.git.' status --porcelain')
    let g:ide.repo.status='git '.len(l:stat)
    "let g:ide.repo.expand=
  elseif isdirectory('.svn')
    let l:stat=systemlist(g:ide.svn.' status')
    "let g:ide.repo.expand
    let g:ide.repo.status='svn '.len(l:stat)
  endif
endfunction
