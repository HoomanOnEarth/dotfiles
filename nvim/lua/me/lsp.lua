local lsp = {}

function lsp.plugins(use)
	use("neovim/nvim-lspconfig")
	use("ray-x/lsp_signature.nvim")
	use("stevearc/aerial.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
end

function lsp.on_attach(client, bufnr)
	-- disable LSP highlight
	client.server_capabilities.semanticTokensProvider = nil

	-- function signature
	require("lsp_signature").on_attach({
		bind = true,
		max_width = vim.fn.winwidth(bufnr),
		padding = " ",
		hint_enable = false,
		hi_parameter = "LspSignatureActiveParameter",
		toggle_key = "<C-k>",
		select_signature_key = "<C-j>",
	}, bufnr)

	-- mapping
	local map = vim.keymap.set
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "gd", vim.lsp.buf.definition, opts)
	map("n", "gD", vim.lsp.buf.declaration, opts)
	map("n", "gT", vim.lsp.buf.type_definition, opts)
	map("n", "K", vim.lsp.buf.hover, opts)
	map("n", "<leader>cf", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	map("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)
	map("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)
	map("n", "<leader>rr", "<CMD>LspRestart<CR>", opts)
	map("n", "<leader>rn", vim.lsp.buf.rename, opts)
	map("n", "<leader>s", "<CMD>Telescope lsp_document_symbols<CR>", opts)
	map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	map("x", "<leader>ca", "<CMD>'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

return lsp
