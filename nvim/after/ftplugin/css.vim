"-- FOLDING --  
set foldmethod=syntax
set foldcolumn=0
set foldlevelstart=99 "start file with all folds opened
setl foldtext=getline(v:foldstart).':\ '.(v:foldend-v:foldstart).'\ lines'
