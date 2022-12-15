local javascript = {}

function javascript.setup()
	require("lspconfig").tsserver.setup({
		init_options = {
			preferences = {
				disableAutomaticTypingAcquisition = true,
				disableSuggestions = true,
			},
		},
		on_attach = require("me.lsp").on_attach,
	})

	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.prettierd,
		},
	})
end

return javascript
