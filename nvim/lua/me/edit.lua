local edit = {}

function edit.plugins(use)
	use("mbbill/undotree")
	use("gbprod/stay-in-place.nvim")
	use("windwp/nvim-autopairs")
end

function edit.setup()
	require("stay-in-place").setup()
	require("nvim-autopairs").setup({ check_ts = false })
	require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

	vim.cmd([[
	if has("persistent_undo")
	   let target_path = expand('~/.config/nvim/.undodir')

		" create the directory and any parent directories
		" if the location does not exist.
		if !isdirectory(target_path)
			call mkdir(target_path, "p", 0700)
		endif

		let &undodir=target_path
		set undofile
	endif
	]])
end

function edit.bindings(map)
	map("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { noremap = true })
	map("n", "j", "gj", { noremap = true })
	map("n", "k", "gk", { noremap = true })
	map("n", "gj", "j", { noremap = true })
	map("n", "gk", "k", { noremap = true })
end

return edit
