local edit = {}

function edit.plugins(use)
	use("gbprod/stay-in-place.nvim")
	use("mbbill/undotree")
end

function edit.setup()
	require("stay-in-place").setup({})

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
end

return edit
