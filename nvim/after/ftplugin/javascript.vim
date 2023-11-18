" enable syntax highlighting for jsdoc
let g:javascript_plugin_jsdoc = 1

"-- FOLDING --  
set foldmethod=syntax "syntax highlighting items specify folds  
set foldcolumn=1 "defines 1 col at window left, to indicate folding  
let javaScript_fold=1 "activate folding by JS syntax  
set foldlevelstart=99 "start file with all folds opened
setl foldtext=getline(v:foldstart).':\ '.(v:foldend-v:foldstart).'\ lines'
