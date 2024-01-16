function! ide#workspace#init(win)
  call ide#lib#win('ws'.a:win)
  execute 'set colorcolumn='.(ide#prop#get('workspacewidth')+1)
  execute 'set numberwidth='.ide#prop#get('numberwidth')
  set relativenumber
  execute 'set statusline=%'.(ide#prop#get('numberwidth')-1).'l'
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
  execute 'set statusline+=%.'.(ide#prop#get('workspacewidth')-40).'f'
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
  call ide#lib#win('last')
endfunction
