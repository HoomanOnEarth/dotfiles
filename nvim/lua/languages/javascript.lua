local javascript = {}
local nvim_lsp = require("lspconfig")

function javascript.setup()
	nvim_lsp.tsserver.setup({
		single_file_support = false,
		init_options = {
			preferences = {
				disableAutomaticTypingAcquisition = true,
				disableSuggestions = true,
			},
		},
		root_dir = nvim_lsp.util.root_pattern("package.json"),
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
