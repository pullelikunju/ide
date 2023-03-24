let g:ide.repo.git='c:\cygwin64\bin\git'
let g:ide.repo.svn='c:\cygwin64\bin\svn'
function! ide#repo#init()
  augroup IDERepoUpdate
    autocmd!
    autocmd DirChanged * call ide#repo#update()
  augroup END
endfunction
function! ide#repo#update()
  if isdirectory('.git')
    let l:stat=systemlist(g:ide.repo.git.' status --porcelain')
    let g:ide.repo.status='git '.len(l:stat)
    "let g:ide.repo.expand=
  elseif isdirectory('.svn')
    let l:stat=systemlist(g:ide.repo.svn.' status')
    "let g:ide.repo.expand
    let g:ide.repo.status='svn '.len(l:stat)
  endif
endfunction
