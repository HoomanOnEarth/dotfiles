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
map <leader>. :silent! clear<CR>:!node %<CR>
map <leader>, :silent! clear<CR>:!jest %:r.spec.js<CR>
map <leader>; :e %:r.spec.js<CR>
