local syntax = {}

function syntax.plugins(use)
	use("sheerun/vim-polyglot")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-treesitter/playground")
end

function syntax.setup()
	require("nvim-treesitter.configs").setup({
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ip"] = "@parameter.inner",
					["ap"] = "@parameter.outer",
				},
			},
		},
	})

	require("treesitter-context").setup({
		enable = true,
		max_lines = 0,
		trim_scope = "outer",
		min_window_height = 0,
	})

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.foldlevel = 99
end

return syntax
