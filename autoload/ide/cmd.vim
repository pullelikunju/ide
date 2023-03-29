function! ide#cmd#start(arg1, arg2)
  if a:arg1 ==? ''
    echo 'Accepted commands are'
    echo '  workspace (ws) <options>'
  elseif a:arg1 ==? 'ws' || a:arg1 ==? 'workspace' 
    call ide#cmdws#cmd(a:arg2)
  endif
endfunction
