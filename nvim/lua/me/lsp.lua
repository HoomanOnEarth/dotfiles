local lsp = {}

function lsp.plugins(use)
	use("neovim/nvim-lspconfig")
	use("ray-x/lsp_signature.nvim")
	use("stevearc/aerial.nvim")
end

function lsp.setup()
	local formatting_autogroup = vim.api.nvim_create_augroup("LspFormatting", {})
	require("null-ls").setup({
		debug = false,
		update_on_insert = false,
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = formatting_autogroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = formatting_autogroup,
					buffer = bufnr,
					callback = vim.lsp.buf.formatting,
				})
			end

			vim.keymap.set("n", "<leader>cf", vim.lsp.buf.formatting, { noremap = true, silent = true, buffer = bufnr })
		end,
	})
end

function lsp.on_attach(client, bufnr)
	-- code outline
	require("aerial").on_attach(client, bufnr)

	-- function signature
	require("lsp_signature").on_attach({
		bind = true,
		padding = " ",
		hint_enable = false,
		toggle_key = "<C-k>",
		hi_parameter = "Search",
	})

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local map = vim.keymap.set
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "gd", vim.lsp.buf.definition, opts)
	map("n", "gD", vim.lsp.buf.declaration, opts)
	map("n", "gT", vim.lsp.buf.type_definition, opts)
	map("n", "K", vim.lsp.buf.hover, opts)
	map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	map("n", "<M-n>", vim.diagnostic.goto_next, opts)
	map("n", "<M-p>", vim.diagnostic.goto_prev, opts)

	map("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)
	map("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)
	map("n", "<leader>rr", "<CMD>LspRestart<CR>", opts)
	map("n", "<leader>rn", vim.lsp.buf.rename, opts)
	map("n", "<leader>s", "<CMD>Telescope lsp_document_symbols<CR>", opts)
	map("n", "<C-Space>", vim.lsp.buf.code_action, opts)
	map("x", "<C-Space>", "<CMD>'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

function lsp.make_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	return require("cmp_nvim_lsp").update_capabilities(capabilities)
end

function lsp.should_format()
	if vim.b.should_format ~= nil then
		return vim.b.should_format
	end

	if vim.g.should_format ~= nil then
		return vim.g.should_format
	end

	return true
end

return lsp
