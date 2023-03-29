" ==============================================================================
" File:        ide.vim
" Description: ide plugin
" Maintainer:  pulleli kunju
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under GPL license
" ==============================================================================

function! s:ide()
  call ide#prop#set('buffertab',          1   ) "Enable buffertab
  call ide#prop#set('buffertabseparator', '  ') "Separator between tabs
  call ide#prop#set('explore',            30  ) "Explore window width
  call ide#prop#set('exploreindent',      '  ') "Indentation explore tree
  call ide#prop#set('git',                'c:\cygwin64\bin\git.exe')
  call ide#prop#set('laststatus',         2   ) "Status bar: 0, 1 or 2
  call ide#prop#set('numberwidth',        4   ) "Width of number; 0 to disable
  call ide#prop#set('shell',              'c:\cygwin64\bin\bash.exe')
  call ide#prop#set('svn',                'c:\cygwin64\bin\svn.exe')
  call ide#prop#set('terminal',           7   ) "Terminal window height
  call ide#prop#set('workspaces',         2   ) "Number of workspace windows
  call ide#prop#set('workspaceheight',    37  ) "Height of workspace window
  call ide#prop#set('workspacewidth',     80  ) "Width of workspace window

  colorscheme ide                         "Theme
  set autoindent                          "Auto indent new lines
  set backspace=eol,indent,start          "Backspace over
  set breakindent                         "Wrapped lines get the same indent
  set clipboard=unnamed                   "Share windows clipboard
  set cursorline                          "Enable highlighting
  set expandtab                           "Convert tab to space
  set fillchars=vert:│,fold:-,eob:\ 
  set guicursor=a:ver10-Cursor/lCursor    "Default cursor
  set guicursor+=n:block-Cursor/lCursor   "Normal mode cursor
  set guicursor+=r:hor25-Cursor/lCursor   "Replace mode cursor
  set guicursor+=v:hor10-Cursor/lCursor   "Replace mode cursor
  if has('nvim')
    set guifont=Courier\ New:h10          "Font and size
  else
    set guifont=Courier_New:h10           "Font and size
  endif
  set hlsearch                            "Highlight search results
  set ignorecase                          "Search case insensitive
  set incsearch                           "Highlight as you type in the search
  set linebreak                           "Don't break word by wrapping
  set list                                "Show white spaces
  set listchars=nbsp:‗,space:·,tab:«\ »   "Symbol for white space
  set mouse=inv                           "Mouse only work in normal mode
  set scrolloff=0                         "Disable jumping when clicked
  set shiftwidth=2                        "Indent selected with >
  set shortmess-=S                        "Show search result summary
  set smartindent                         "Indent for braces
  set spell spelllang=en_us               "Enable spell check
  set tabstop=2                           "Tab width
  set titlestring=%{ide#lib#cwd()}        "Set title to working folder
  set visualbell                          "Disable bell sound
  set wildmenu
  set wildmode=longest,list,full
  set wrap                                "Enable line wrap
  syntax enable                           "Language syntax highlight
endfunction
function! s:idestart(arg1='', arg2='')
  if ide#prop#init()
    call s:ide()
    call ide#lib#init()
  else
    call ide#cmd#start(a:arg1, a:arg2)
  endif
endfunction
augroup IDEStart
  autocmd!
  autocmd VimEnter * call s:idestart()
augroup END
command! -nargs=* IDE call s:idestart(<f-args>)
