local completion = {}

function completion.plugins(use)
	use("windwp/nvim-autopairs")
	use("hrsh7th/vim-vsnip")
	use("hrsh7th/vim-vsnip-integ")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
end

function completion.setup()
	local cmp = require("cmp")
	local opts = { "i", "s", "c" }

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = {
			["<C-g>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), opts),
			["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), opts),
			["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), opts),
			["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), opts),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), opts),
			["<C-e>"] = cmp.mapping(cmp.mapping.close(), opts),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "vsnip" },
			{ name = "nvim_lua" },
		},
	})

	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "cmdline" },
			{ name = "path" },
		}),
	})

	require("nvim-autopairs").setup({
		check_ts = true,
	})

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

function completion.bindings(map)
	vim.cmd([[
	  imap <expr> <C-j> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-j>'
	  smap <expr> <C-j> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-j>'
	]])

	map("n", "gZ", "<Plug>(vsnip-select-text)", {})
	map("x", "gZ", "<Plug>(vsnip-select-text)", {})
	map("n", "gz", "<Plug>(vsnip-cut-text)", {})
	map("x", "gz", "<Plug>(vsnip-cut-text)", {})
end

return completion
