local aerial = {}

function aerial.setup()
	require("aerial").setup({
		layout = {
			min_width = 10,
			max_width = { 40, 0.25 },
			default_direction = "prefer_left",
		},
	})
end

function aerial.bindings(map)
	map("n", "<Leader>o", "<CMD>AerialToggle<Cr>", {})
	map("n", "<C-f>", require("api.telescope-aerial").get_symbols, { silent = true })
end

return aerial
