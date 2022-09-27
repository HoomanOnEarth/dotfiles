local javascript = {}

function javascript.plugins(use)
	use({ "tree-sitter/tree-sitter-javascript", run = ":TSInstall javascript" })
	use("jose-elias-alvarez/null-ls.nvim")
end

function javascript.setup()
	local null_ls = require("null-ls")
	null_ls.register(null_ls.builtins.formatting.prettier.with({
		args = { "--stdin-filepath", "$FILENAME" },
		runtime_condition = require("me.lsp").should_format,
	}))

	require("lspconfig").tsserver.setup({
		on_attach = function(client, bufnr)
			client.resolved_capabilities.document_formatting = false
			require("me.lsp").on_attach(client, bufnr)
		end,
		capabilities = require("me.lsp").make_capabilities(),
	})
end

return javascript
