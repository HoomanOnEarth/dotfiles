command! Scratch vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile number

" c development mappings
map <leader>, :redir! @o<CR>:silent !gcc -o %:r % && ./%:r<CR>:redir END<CR>:Scratch<CR>"op<C-w>p
map <leader>. :redir! @o<CR>:!otool -tv %:r<CR>:redir END<CR>:Scratch<CR>"op<C-w>p
