function! ide#terminal#init()
  call ide#lib#win('terminal')
  if has('nvim')
    execute 'terminal '.ide#prop#get('shell').' -l'
  else
    execute 'terminal ++curwin ++kill=term ++shell '.ide#prop#get('shell').' -l'
  endif
  setlocal bufhidden=delete
  setlocal buftype=terminal
  setlocal colorcolumn=0
  setlocal filetype=--terminal--
  setlocal matchpairs=
  setlocal nobuflisted
  setlocal nocursorline
  setlocal nolist
  setlocal nonumber
  setlocal norelativenumber
  setlocal noruler
  setlocal nospell
  setlocal noswapfile
  setlocal statusline=\ 
  setlocal winfixheight
  call ide#lib#win('last')
endfunction
