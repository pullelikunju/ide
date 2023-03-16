let s:color = {
  \ 'black':      '#282C34',
  \ 'blue':       '#61AFEF',
  \ 'comment':    '#5C6370',
  \ 'cursor':     '#2C323C',
  \ 'cyan':       '#56B6C2',
  \ 'gray':       '#3B4048',
  \ 'green':      '#98C379',
  \ 'gutter':     '#4B5263',
  \ 'purple':     '#C678DD',
  \ 'red':        '#E06C75',
  \ 'redD':       '#BE5046',
  \ 'special':    '#3B4048',
  \ 'visual':     '#3E4452',
  \ 'white':      '#ABB2BF',
  \ 'yellow':     '#E5C07B',
  \ 'yellowD':    '#D19A66'
\}
hi clear
syntax reset
set background=dark
let s:opts={'bg': 'guibg', 'fg': 'guifg', 'gui': 'gui'}
for s:ln in [
  \{'id': 'Boolean',         'fg': 'yellowD'},
  \{'id': 'Character',       'fg': 'green'},
  \{'id': 'ColorColumn',                      'bg': 'cursor'},
  \{'id': 'Comment',         'fg': 'comment',                 'gui': 'italic'},
  \{'id': 'Conditional',     'fg': 'purple'},
  \{'id': 'Constant',        'fg': 'cyan'},
  \{'id': 'Cursor',          'fg': 'black',   'bg': 'blue'},
  \{'id': 'CursorColumn',                     'bg': 'cursor'},
  \{'id': 'CursorLine',                       'bg': 'cursor'},
  \{'id': 'Define',          'fg': 'purple'},
  \{'id': 'DiffAdd',         'fg': 'black',   'bg': 'green'},
  \{'id': 'DiffChange',      'fg': 'yellow',               'gui': 'underline'},
  \{'id': 'DiffDelete',      'fg': 'black',   'bg': 'red'},
  \{'id': 'DiffText',        'fg': 'black',   'bg': 'yellow'},
  \{'id': 'Directory',       'fg': 'blue'},
  \{'id': 'EndOfBuffer',     'fg': 'black'},
  \{'id': 'Error',           'fg': 'red',     'bg': 'black'},
  \{'id': 'ErrorMsg',        'fg': 'red',     'bg': 'black'},
  \{'id': 'Exception',       'fg': 'purple'},
  \{'id': 'File',            'fg': 'green'},
  \{'id': 'FileSel',         'fg': 'black',   'bg': 'green'},
  \{'id': 'Float',           'fg': 'yellowD'},
  \{'id': 'Folded',          'fg': 'comment'},
  \{'id': 'Function',        'fg': 'blue'},
  \{'id': 'Identifier',      'fg': 'red'},
  \{'id': 'IncSearch',       'fg': 'yellow',  'bg': 'comment'},
  \{'id': 'Include',         'fg': 'blue'},
  \{'id': 'Keyword',         'fg': 'purple'},
  \{'id': 'Label',           'fg': 'purple'},
  \{'id': 'LineNr',          'fg': 'gutter',  'bg': 'cursor'},
  \{'id': 'Macro',           'fg': 'purple'},
  \{'id': 'MatchParen',      'fg': 'blue',                 'gui': 'underline'},
  \{'id': 'NonText',         'fg': 'special'},
  \{'id': 'Normal',          'fg': 'white',   'bg': 'black'},
  \{'id': 'Number',          'fg': 'yellowD'},
  \{'id': 'Operator',        'fg': 'purple'},
  \{'id': 'Pmenu',           'fg': 'white',   'bg': 'special'},
  \{'id': 'PmenuSbar',                        'bg': 'cursor'},
  \{'id': 'PmenuSel',        'fg': 'cursor',  'bg': 'blue'},
  \{'id': 'PmenuThumb',                       'bg': 'white'},
  \{'id': 'PreCondit',       'fg': 'yellow'},
  \{'id': 'PreProc',         'fg': 'yellow'},
  \{'id': 'Question',        'fg': 'purple'},
  \{'id': 'QuickFixLine',    'fg': 'black',   'bg': 'yellow'},
  \{'id': 'Repeat',          'fg': 'purple'},
  \{'id': 'Search',          'fg': 'white',   'bg': 'visual'},
  \{'id': 'Special',         'fg': 'blue'},
  \{'id': 'SpecialChar',     'fg': 'yellowD'},
  \{'id': 'SpecialComment',  'fg': 'comment'},
  \{'id': 'SpecialKey',      'fg': 'gutter'},
  \{'id': 'SpellBad',        'fg': 'red',                  'gui': 'underline'},
  \{'id': 'SpellCap',        'fg': 'yellowD'},
  \{'id': 'SpellLocal',      'fg': 'yellowD'},
  \{'id': 'SpellRare',       'fg': 'yellowD'},
  \{'id': 'Statement',       'fg': 'purple'},
  \{'id': 'StatusLine',      'fg': 'comment', 'bg': 'black'},
  \{'id': 'StatusLineNC',    'fg': 'gray'},
  \{'id': 'StorageClass',    'fg': 'yellow'},
  \{'id': 'String',          'fg': 'green'},
  \{'id': 'Structure',       'fg': 'yellow'},
  \{'id': 'TabLine',         'fg': 'white',   'bg': 'comment', 'gui': 'none'},
  \{'id': 'TabLineFill',     'fg': 'green',   'bg': 'black'},
  \{'id': 'TabLineSel',      'fg': 'green'},
  \{'id': 'Terminal',        'fg': 'white',   'bg': 'black'},
  \{'id': 'Title',           'fg': 'green'},
  \{'id': 'Todo',            'fg': 'purple'},
  \{'id': 'Type',            'fg': 'yellow'},
  \{'id': 'Typedef',         'fg': 'yellow'},
  \{'id': 'Underlined',                                    'gui': 'underline'},
  \{'id': 'VertSplit',       'fg': 'special',              'gui':'none'},
  \{'id': 'Visual',                           'bg': 'visual'},
  \{'id': 'VisualNOS',                        'bg': 'visual'},
  \{'id': 'WarningMsg',      'fg': 'yellow'},
  \{'id': 'WildMenu',        'fg': 'black',   'bg': 'blue'}
\]
  if exists('s:ln.id')
    let s:hl=''
    for s:opt in keys(s:opts)
      if exists('s:ln[s:opt]')
        let s:hl.=' '.s:opts[s:opt].'='
        if exists('s:color[s:ln[s:opt]]')
          let s:hl.=s:color[s:ln[s:opt]]
        else
          let s:hl.=s:ln[s:opt]
        endif
      endif
    endfor
    if s:hl !=# ''
      execute 'highlight '.s:ln.id.s:hl
    endif
  endif
endfor
