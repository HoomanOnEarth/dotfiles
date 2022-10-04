local edit = {}

function edit.plugins(use)
	use("mbbill/undotree")
	use("gbprod/stay-in-place.nvim")
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")
end

function edit.setup()
	require("nvim-ts-autotag").setup()

	require("stay-in-place").setup()

	require("nvim-autopairs").setup({ check_ts = true })

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

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
