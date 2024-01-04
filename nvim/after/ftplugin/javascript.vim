" enable syntax highlighting for jsdoc
let g:javascript_plugin_jsdoc=1

" activate folding by JS syntax
let javaScript_fold=1

"-- FOLDING --  
set fillchars=fold:\ 
set foldmethod=syntax "syntax highlighting items specify folds  
set foldcolumn=1 "defines 1 col at window left, to indicate folding  
set foldlevelstart=1 "start file with all folds opened
setl foldtext=MyFold()
hi Folded guifg=none guibg=none

function! MyFold()
  return substitute(getline(v:foldstart), '[{|\[|(]$', '‹...›', '')
endfunction
