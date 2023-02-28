" ============================================================================
" File:        ide.vim
" Description: ide plugin
" Maintainer:  pulleli kunju
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under GPL license
" ============================================================================
function! IDE()
  if !exists('g:ide')
    let g:ide={}
    let g:ide.border=1                    "Border width set by theme
    let g:ide.buffertab=1                 "Height of buffertab; 0 to disable
    let g:ide.explore=30                  "Width of explore; 0 to disable
    let g:ide.exploreindent='  '          "Indentation for tree levels
    let g:ide.numberwidth=4               "Width to use for number; 0 to disable
    let g:ide.laststatus=2                "Status bar: 0, 1 or 2
    let g:ide.workspaces=2                "Number of workspace windows
    let g:ide.workspaceheight=24          "Height of workspace window
    let g:ide.workspacewidth=80           "Width of workspace window

    colorscheme slate                     "Theme
    set autoindent                        "Auto indent new lines
    set backspace=eol,indent,start        "Backspace over
    set breakindent                       "Wrapped lines get the same indent
    set cursorline                        "Enable highlighting
    set expandtab                         "Convert tab to space
    set hlsearch                          "Highlight search results
    set linebreak                         "Don't break word by wrapping
    set list                              "Show white spaces
    set listchars=nbsp:‗,space:·,tab:«·»  "Symbol for white space
    set mouse=inv                         "Mouse only work in normal mode
    set scrolloff=0                       "Disable jumping when clicked
    set shiftwidth=2                      "Indent selected with >
    set shortmess-=S                      "Show search result summary
    set smartindent                       "Indent for braces
    set spell spelllang=en_us             "Enable spell check
    set tabstop=2                         "Tab width
    set titlestring=%{ide#ide#cwd()}      "Set title to working folder
    set visualbell                        "Disable bell sound
    set wrap                              "Enable line wrap
    syntax enable                         "Language syntax highlight

    call ide#ide#init()
  endif
endfunction
augroup IDEStart
  autocmd!
  autocmd VimEnter * call IDE()
augroup END
