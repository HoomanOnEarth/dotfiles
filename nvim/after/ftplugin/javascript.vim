let g:javascript_plugin_jsdoc = 1
let javaScript_fold = 1

function! MyFold()
	return substitute(getline(v:foldstart), '[{|\[|(]$', '‹...›', '')
endfunction

set foldmethod=syntax
set foldtext=MyFold()
set foldlevelstart=1

hi Folded guifg=none guibg=none
