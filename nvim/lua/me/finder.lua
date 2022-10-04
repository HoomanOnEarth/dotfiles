local finder = {}

function finder.plugins(use)
	use("nvim-telescope/telescope.nvim")
end

function finder.setup()
	local action_layout = require("telescope.actions.layout")
	local previewers = require("telescope.previewers")
	local themes = require("telescope.themes")
	local ivy_theme_config = { sorting_strategy = "ascending", prompt_position = "bottom" }
	local default_opts = themes.get_ivy(ivy_theme_config)

	require("telescope").setup({
		defaults = vim.tbl_deep_extend("force", {
			preview = {
				hide_on_startup = true,
			},
			mappings = {
				i = {
					["<C-x>"] = false,
					["<C-h>"] = action_layout.toggle_preview,
					["<M-m>"] = action_layout.toggle_mirror,
				},
			},
			buffer_previewer_maker = function(filepath, bufnr, opts)
				opts = opts or {}
				---@diagnostic disable-next-line: missing-parameter
				filepath = vim.fn.expand(filepath)
				vim.loop.fs_stat(filepath, function(_, stat)
					if not stat then
						return
					end
					if stat.size > 100000 then
						return
					else
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					end
				end)
			end,
		}, default_opts),
	})
end

function finder.bindings(map)
	map("n", "<Leader>dl", "<CMD>lua require 'telescope.builtin'.diagnostics()<CR>", {})
	map("n", "<Leader>h", "<CMD>lua require 'telescope.builtin'.help_tags()<CR>", {})
	map("n", "<Leader>b", "<CMD>lua require 'telescope.builtin'.buffers()<CR>", {})
	map("n", "<Leader>f", "<CMD>lua require 'telescope.builtin'.live_grep()<CR>", {})
	map("n", "<C-s>", "<CMD>lua require 'telescope.builtin'.current_buffer_fuzzy_find()<CR>", {})
	map("n", "<C-p>", "<CMD>lua require 'telescope.builtin'.find_files()<CR>", {})
	map("n", "<Leader>p", "<CMD>lua require 'telescope.builtin'.git_files()<CR>", {})
	map("n", "<C-g>", require("api.telescope").change_project, {})
end

return finder
