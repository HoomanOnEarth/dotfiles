local lua = {}

function lua.plugins(use)
	use({ "nvim-treesitter/tree-sitter-query", run = ":TSInstall query" })
	use("folke/lua-dev.nvim")
end

function lua.setup()
	local null_ls = require("null-ls")
	null_ls.register(null_ls.builtins.formatting.stylua.with({
		runtime_condition = require("me.lsp").should_format,
	}))

	local luadev = require("lua-dev").setup({
		lspconfig = {
			on_attach = function(client, bufnr)
				client.resolved_capabilities.document_formatting = false
				require("me.lsp").on_attach(client, bufnr)
			end,
			capabilities = require("me.lsp").make_capabilities(),
		},
	})

	require("lspconfig").sumneko_lua.setup(luadev)
end

return lua
