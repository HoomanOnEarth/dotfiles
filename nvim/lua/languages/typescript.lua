local typescript = {}
local nvim_lsp = require("lspconfig")

function typescript.setup()
	nvim_lsp.denols.setup({
		root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
		on_attach = require("me.lsp").on_attach,
	})

	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.deno_fmt,
		},
	})
end

return typescript
