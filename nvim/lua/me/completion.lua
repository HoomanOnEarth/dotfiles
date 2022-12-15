local completion = {}

function completion.plugins(use)
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")

	use("hrsh7th/vim-vsnip")
	use("hrsh7th/cmp-vsnip")
end

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

function completion.setup()
	local cmp = require("cmp")

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete({}),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif vim.fn["vsnip#available"](1) == 1 then
					feedkey("<Plug>(vsnip-expand-or-jump)", "")
				elseif has_words_before() then
					cmp.complete()
				else
					fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
				end
			end, { "i", "s", "c" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif vim.fn["vsnip#jumpable"](-1) == 1 then
					feedkey("<Plug>(vsnip-jump-prev)", "")
				else
					fallback()
				end
			end, { "i", "s", "c" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "vsnip" },
		}, {
			{ name = "buffer" },
		}),
	})

	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "cmdline" },
			{ name = "path" },
		}),
	})
end

function completion.bindings(map)
	vim.cmd([[
	" Expand or jump
	imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
	smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

	" Jump forward or backward
	imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
	smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
	imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
	smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
	]])

	map("n", "gZ", "<Plug>(vsnip-select-text)", {})
	map("x", "gZ", "<Plug>(vsnip-select-text)", {})
	map("n", "gz", "<Plug>(vsnip-cut-text)", {})
	map("x", "gz", "<Plug>(vsnip-cut-text)", {})
end

return completion
