local javascript = {}

function javascript.plugins(use)
	use("jose-elias-alvarez/null-ls.nvim")
end

function javascript.setup()
	require("lspconfig").tsserver.setup({
		on_attach = function(client, bufnr)
			client.server_capabilities.document_formatting = false
			require("me.lsp").on_attach(client, bufnr)
		end,
		capabilities = require("me.lsp").make_capabilities(),
	})
end

return javascript
