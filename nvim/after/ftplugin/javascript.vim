iabbrev #b /*******************************************************************************
iabbrev #e ****************************************************************************/

let g:javascript_plugin_jsdoc = 1
let javaScript_fold = 1

function! MyFold()
  return substitute(getline(v:foldstart), '[{|\[|(]$', '‹...›', '')
endfunction

set foldmethod=syntax
set foldtext=MyFold()
set foldlevelstart=0

hi Folded guifg=none guibg=none

au BufWinLeave *.js mkview

" javascript development mappings
map <leader>. :!clear && node %<CR>
map <leader>, :!clear && jest %:r.spec.js<CR>
