local lsp = {}

function lsp.plugins(use)
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/null-ls.nvim")
end

function lsp.on_attach(client, bufnr)
	-- disable LSP highlight
	client.server_capabilities.semanticTokensProvider = nil

	-- mapping
	local map = vim.keymap.set
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "gd", vim.lsp.buf.definition, opts)
	map("n", "gD", vim.lsp.buf.declaration, opts)
	map("n", "gT", vim.lsp.buf.type_definition, opts)
	map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	map("n", "K", vim.lsp.buf.hover, opts)
	map("v", "gq", vim.lsp.buf.format, opts)
	map("n", "gq", vim.lsp.buf.format, opts)
	map("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)
	map("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)
	map("n", "<leader>rr", "<CMD>LspRestart<CR>", opts)
	map("n", "<leader>rn", vim.lsp.buf.rename, opts)
	map("n", "<leader>s", "<CMD>Telescope lsp_document_symbols<CR>", opts)
	map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	map("x", "<leader>ca", "<CMD>'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

return lsp
