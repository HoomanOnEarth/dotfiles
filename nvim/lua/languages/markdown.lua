local markdown = {}

function markdown.setup()
vim.cmd([[
augroup SETUP_MARKDOWN
    autocmd!
	au BufRead,BufNewFile *.md setlocal textwidth=80
	au BufRead,BufNewFile *.md setlocal formatexpr=
augroup END
]])
end

return markdown
