local rust = {}

function rust.plugins(use)
	use("simrat39/rust-tools.nvim")
end

function rust.setup()
	require("rust-tools").setup({
		tools = {
		},
		server = {
			on_attach = require("me.lsp").on_attach,
		},
	})
end

return rust
