local javascript = {}

function javascript.setup()
	require("lspconfig").tsserver.setup({
		init_options = {
			preferences = {
				disableSuggestions = true,
			},
		},
		on_attach = function(client, bufnr)
			-- disable default formatter
			client.server_capabilities.document_formatting = false

			require("me.lsp").on_attach(client, bufnr)
		end,
		capabilities = require("me.lsp").default_capabilities(),
	})

	local null_ls = require("null-ls")
	null_ls.register(null_ls.builtins.formatting.prettierd.with({
		extra_filetypes = { "javascript", "javascriptreact" },
		runtime_condition = require("me.lsp").should_format,
	}))
end

return javascript
