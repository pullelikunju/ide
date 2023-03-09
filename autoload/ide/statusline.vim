function! ide#statusline#init()
  if g:ide.laststatus ># 0
    let &statusline='%'.(g:ide.numberwidth-1).'l'
    set statusline+=:
    set statusline+=%c
    set statusline+=\ 
    set statusline+=%h
    set statusline+=%m
    set statusline+=%q
    set statusline+=%r
    set statusline+=%w
    set statusline+=\ 
    set statusline+=%n
    set statusline+=:
    let &statusline.='%.'.(g:ide.workspacewidth-34).'f'
    set statusline+=%=
    set statusline+=%{&filetype}
    set statusline+=\ 
    set statusline+=%{&fileformat}
    set statusline+=\ 
    set statusline+=%{&encoding}
    set statusline+=\ 
    set statusline+=%p
    set statusline+=%%
    set statusline+=\ 
    set statusline+=/
    set statusline+=\ 
    set statusline+=%L
    set statusline+=\ 
  endif
endfunction
