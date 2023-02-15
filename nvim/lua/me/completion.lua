local completion = {}

function completion.plugins(use)
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-nvim-lsp-document-symbol")

	use("hrsh7th/vim-vsnip")
	use("hrsh7th/vim-vsnip-integ")
	use("rafamadriz/friendly-snippets")
end

local lspkind_comparator = function(conf)
	local lsp_types = require("cmp.types").lsp
	return function(entry1, entry2)
		if entry1.source.name ~= "nvim_lsp" then
			if entry2.source.name == "nvim_lsp" then
				return false
			else
				return nil
			end
		end
		local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
		local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

		local priority1 = conf.kind_priority[kind1] or 0
		local priority2 = conf.kind_priority[kind2] or 0
		if priority1 == priority2 then
			return nil
		end
		return priority2 < priority1
	end
end

local label_comparator = function(entry1, entry2)
	return entry1.completion_item.label < entry2.completion_item.label
end

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

function completion.setup()
	local cmp = require("cmp")
	local compare = require("cmp.config.compare")

	cmp.setup({
		enabled = function()
			-- disable completion in comments
			local context = require("cmp.config.context")

			-- disable in prompt
			local buftype = vim.api.nvim_buf_get_option(0, "buftype")
			if buftype == "prompt" then
				return false
			end

			-- keep command mode completion enabled when cursor is in a comment
			if vim.api.nvim_get_mode().mode == "c" then
				return true
			else
				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end
		end,

		sorting = {
			comparators = {
				lspkind_comparator({
					kind_priority = {
						Snippet = 12,
						Field = 11,
						Property = 11,
						Constant = 10,
						Enum = 10,
						EnumMember = 10,
						Event = 10,
						Function = 10,
						Method = 10,
						Operator = 10,
						Reference = 10,
						Struct = 10,
						Variable = 9,
						File = 8,
						Folder = 8,
						Class = 5,
						Color = 5,
						Module = 5,
						Keyword = 2,
						Constructor = 1,
						Interface = 1,
						Text = 1,
						TypeParameter = 1,
						Unit = 1,
						Value = 1,
					},
				}),
				label_comparator,
			},
		},

		sources = cmp.config.sources({
			{ name = "vsnip" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_document_symbol" },
		}),

		completion = {
			max_item_count = 10,
			keyword_length = 2,
		},

		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},

		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif vim.fn["vsnip#available"](1) == 1 then
					feedkey("<Plug>(vsnip-expand-or-jump)", "")
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
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
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})

	vim.cmd([[
		let g:vsnip_filetypes = {}
		let g:vsnip_filetypes.javascriptreact = ['javascript']
		let g:vsnip_filetypes.liquid = ['html']
	]])
end

function completion.bindings(map)
	vim.cmd([[
	" Expand
	imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
	smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

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
