local ui = {}

function ui.plugins(use)
	use("rose-pine/neovim")
	use("kyazdani42/nvim-web-devicons")
end

function ui.setup()
	vim.opt.background = "light"
	vim.cmd("colorscheme rose-pine")
end

function ui.bindings()
	vim.cmd([[
	cnoreabbrev h vertical help
	cnoreabbrev qa confirm qa
	cnoreabbrev q confirm q
	]])
end

return ui
