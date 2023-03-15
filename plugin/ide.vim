" ==============================================================================
" File:        ide.vim
" Description: ide plugin
" Maintainer:  pulleli kunju
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under GPL license
" ==============================================================================
function! g:IDE(ide='')
  if !exists('g:ide')
    let g:ide={}
    let g:ide.buffertab=1                 "Height of buffertab
    let g:ide.buffertabseparator='  '     "Separator between tabs
    let g:ide.explore=30                  "Width of explore
    let g:ide.exploreindent='  '          "Indentation for tree levels
    let g:ide.numberwidth=4               "Width to use for number; 0 to disable
    let g:ide.laststatus=2                "Status bar: 0, 1 or 2
    let g:ide.workspaces=2                "Number of workspace windows
    let g:ide.workspaceheight=34          "Height of workspace window
    let g:ide.workspacewidth=80           "Width of workspace window

    colorscheme ide                       "Theme
    set autoindent                        "Auto indent new lines
    set backspace=eol,indent,start        "Backspace over
    set breakindent                       "Wrapped lines get the same indent
    set cursorline                        "Enable highlighting
    set expandtab                         "Convert tab to space
    set fillchars=vert:│,fold:-,eob:\ 
    set guicursor=a:ver10-Cursor/lCursor  "Default cursor
    set guicursor+=n:block-Cursor/lCursor "Normal mode cursor
    set guicursor+=r:hor25-Cursor/lCursor "Replace mode cursor
    set guicursor+=v:hor10-Cursor/lCursor "Replace mode cursor
    set guifont=Courier_New:h10           "Font and size
    set hlsearch                          "Highlight search results
    set linebreak                         "Don't break word by wrapping
    set list                              "Show white spaces
    set listchars=nbsp:‗,space:·,tab:«\ » "Symbol for white space
    set mouse=inv                         "Mouse only work in normal mode
    set scrolloff=0                       "Disable jumping when clicked
    set shiftwidth=2                      "Indent selected with >
    set shortmess-=S                      "Show search result summary
    set smartindent                       "Indent for braces
    set spell spelllang=en_us             "Enable spell check
    set tabstop=2                         "Tab width
    set titlestring=%{ide#ide#cwd()}      "Set title to working folder
    set visualbell                        "Disable bell sound
    set wildmenu
    set wildmode=longest,list,full
    set wrap                              "Enable line wrap
    syntax enable                         "Language syntax highlight

    call ide#ide#init()
  else
    call ide#workspace#cmd(a:ide)
  endif
endfunction
"augroup IDEStart
"  autocmd!
"  autocmd VimEnter * call g:IDE()
"augroup END
command! -nargs=* IDE call IDE(<f-args>)
