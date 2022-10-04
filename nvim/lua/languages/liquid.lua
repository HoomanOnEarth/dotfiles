local liquid = {}

function liquid.plugins(use)
	use("jose-elias-alvarez/null-ls.nvim")
end

function liquid.setup()
	local null_ls = require("null-ls")
	null_ls.register(null_ls.builtins.formatting.prettier.with({
		args = { "--stdin-filepath", "$FILENAME" },
		extra_filetypes = { "liquid" },
		runtime_condition = require("me.lsp").should_format,
	}))
end

return liquid
