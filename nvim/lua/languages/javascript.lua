local javascript = {}

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
