local lua = {}

function lua.plugins(use)
	use({ "nvim-treesitter/tree-sitter-query", run = ":TSInstall query" })
	use("folke/neodev.nvim")
end

function lua.setup()
	local null_ls = require("null-ls")
	null_ls.register(null_ls.builtins.formatting.stylua.with({
		runtime_condition = require("me.lsp").should_format,
	}))

	require("neodev").setup({
		library = {
			enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
			runtime = true, -- runtime path
			types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
			plugins = true, -- installed opt or start plugins in packpath
		},
	})

	require("lspconfig").sumneko_lua.setup({
		on_attach = require("me.lsp").on_attach,
		capabilities = require("me.lsp").make_capabilities(),
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	})
end

return lua
