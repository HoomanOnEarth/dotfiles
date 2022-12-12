local liquid = {}

function liquid.setup()
	local null_ls = require("null-ls")
	null_ls.register(null_ls.builtins.formatting.prettierd.with({
		extra_filetypes = { "liquid" },
		runtime_condition = require("me.lsp").should_format,
	}))
end

return liquid
