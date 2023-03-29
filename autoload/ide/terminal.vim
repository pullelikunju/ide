function! ide#terminal#init()
  call ide#lib#win('terminal')
  execute 'terminal ++curwin ++kill=term ++shell '.ide#prop#get('shell').' -l'
  setlocal bufhidden=delete
  setlocal buftype=nofile
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
  setlocal winfixwidth
  call ide#lib#win('last')
endfunction
