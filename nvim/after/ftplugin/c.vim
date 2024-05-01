" c development mappings
map <leader>, :silent!clear<CR>:!gcc -o %:r %<CR>
map <leader>. :silent!clear<CR>:!otool -tv %:r<CR>
map <leader>/ <leader>,<leader>.
