vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "i", "v" }, "<C-c>", "<ESC>")
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
vim.keymap.set("n", "j", 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

-- diagnostic
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- create empty lines
vim.keymap.set("n", "[<space>", ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[")
vim.keymap.set("n", "]<space>", ":<c-u>put =repeat(nr2char(10), v:count1)<cr>")

-- quick moving lines
vim.keymap.set("n", "[e", ":<c-u>execute 'move -1-'. v:count1<cr>")
vim.keymap.set("n", "]e", ":<c-u>execute 'move +'. v:count1<cr>")

-- quickly edit macro
vim.keymap.set(
	"n",
	"<leader>m",
	":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>"
)

vim.o.mouse = "a"
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.breakindent = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.wrap = false
vim.o.statusline = 2
vim.o.synmaxcol = 200
vim.o.complete = vim.o.complete:gsub("ti", "")

vim.o.tabstop = 4 -- number of visual spaces per TAB
vim.o.softtabstop = 4 -- number of spaces in tab when editing
vim.o.shiftwidth = 4 -- number of spaces to use for autoindent
vim.o.expandtab = true -- tabs are space
vim.o.autoindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 420
vim.o.completeopt = "menuone,noselect"

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		vim.o.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		vim.o.cursorline = false
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		-- disable auto comment on new line
		vim.o.formatoptions = vim.o.formatoptions:gsub("cro", "")

		-- remember cursor position
		vim.cmd([[
		if line("'\"") > 1 && line("'\"") <= line("$")
			execute "normal! g`\"zz"
		endif
		]])
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- UI
	{
		"rose-pine/neovim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000,
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			vim.o.background = "light"
			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- Terminals
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				shade_terminals = false,
				open_mapping = [[<C-\>]],
				direction = "vertical",
				size = 80,
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},

	-- Syntax
	"sheerun/vim-polyglot",

	-- Code folds
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set({ "n", "v" }, "zR", require("ufo").openAllFolds)
			vim.keymap.set({ "n", "v" }, "zM", require("ufo").closeAllFolds)
			vim.keymap.set({ "n", "v" }, "zr", require("ufo").openFoldsExceptKinds)
			vim.keymap.set({ "n", "v" }, "zm", require("ufo").closeFoldsWith)
			vim.keymap.set("n", "K", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { noremap = true })

			require("ufo").setup()
		end,
	},

	-- Undotree
	{
		"mbbill/undotree",
		config = function()
			vim.cmd([[
			if has("persistent_undo")
				let target_path = expand('~/.config/nvim/.undodir')
				if !isdirectory(target_path)
					call mkdir(target_path, "p", 0700)
				endif
				let &undodir=target_path
				set undofile
			endif
			]])

			vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true })
		end,
	},

	-- Tmux plugins
	"christoomey/vim-tmux-navigator",

	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"folke/neodev.nvim",
		},
		config = function()
			require("neodev").setup()
			require("mason").setup()

			local servers = {
				rust_analyzer = {},
				tsserver = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			}

			local on_attach = function(client, bufnr)
				-- disable LSP highlight
				client.server_capabilities.semanticTokensProvider = nil

				-- mapping
				local map = vim.keymap.set
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end
					map("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>rr", ":LspRestart<CR>")
				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				nmap("gT", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
				nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				nmap("<C-s>", vim.lsp.buf.signature_help, "Signature Documentation")

				vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })

				map({ "n", "v" }, "gq", ":Format<CR>")
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
			mason_lspconfig.setup_handlers({
				function(server_name)
					local opts = {
						on_attach = on_attach,
						capabilities = capabilities,
						settings = servers[server_name],
					}

					if server_name == "tsserver" then
						opts.init_options = {
							preferences = {
								disableAutomaticTypingAcquisition = true,
								disableSuggestions = true,
							},
						}
					end

					require("lspconfig")[server_name].setup(opts)
				end,
			})

			local null_ls = require("null-ls")
			null_ls.setup({
				on_attach = on_attach,
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier.with({
						extra_args = { "--no-semi", "--single-quote" },
					}),
				},
			})

			null_ls.register({
				name = "svg",
				filetypes = { "svg" },
				sources = {
					null_ls.builtins.formatting.prettier.with({
						extra_args = { "--no-semi", "--single-quote", "--parser", "html" },
					}),
				},
			})
		end,
	},

	-- Autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})
			require("luasnip.loaders.from_vscode").lazy_load()

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

			cmp.setup({
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
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
				completion = {
					max_item_count = 10,
					keyword_length = 2,
				},
			})
		end,
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
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
							["<C-u>"] = false,
							["<C-d>"] = false,
							["<C-x>"] = false,
							["<C-h>"] = action_layout.toggle_preview,
						},
					},
					buffer_previewer_maker = function(filepath, bufnr, opts)
						opts = opts or {}
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

			vim.keymap.set(
				"n",
				"<leader>?",
				require("telescope.builtin").oldfiles,
				{ desc = "[?] Find recently opened files" }
			)
			vim.keymap.set(
				"n",
				"<leader><space>",
				require("telescope.builtin").buffers,
				{ desc = "[ ] Find existing buffers" }
			)
			vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>p", require("telescope.builtin").git_files, { desc = "[S]earch [G]it Files" })
			vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set(
				"n",
				"<leader>sw",
				require("telescope.builtin").grep_string,
				{ desc = "[S]earch current [W]ord" }
			)
			vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set(
				"n",
				"<leader>sd",
				require("telescope.builtin").diagnostics,
				{ desc = "[S]earch [D]iagnostics" }
			)
			vim.keymap.set("n", "<C-f>", ":lua require 'telescope.builtin'.current_buffer_fuzzy_find()<CR>", {})
			vim.keymap.set("n", "<C-g>", require("api.telescope").change_project, {})
		end,
	},

	-- Adds git releated signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Editing
	{ "gbprod/stay-in-place.nvim", opts = {} },

	-- Useful plugins
	{
		"echasnovski/mini.animate",
		config = function()
			local animate = require("mini.animate")
			local subscroll_120 = animate.gen_subscroll.equal({ max_output_steps = 120 })
			animate.setup({
				cursor = {
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
					subscroll = subscroll_120,
				},
				scroll = {
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
					subscroll = subscroll_120,
				},
				resize = { enable = false },
				open = { enable = false },
				close = { enable = false },
			})
		end,
	},
	{
		"echasnovski/mini.statusline",
		config = function()
			require("mini.statusline").setup()
			vim.api.nvim_exec("hi link MiniStatuslineModeNormal Search", false)
		end,
	},
	{
		"echasnovski/mini.bufremove",
		config = function()
			require("mini.bufremove").setup()
		end,
	},
	{
		"echasnovski/mini.comment",
		config = function()
			require("mini.comment").setup()
		end,
	},
	{
		"echasnovski/mini.indentscope",
		config = function()
			require("mini.indentscope").setup()
		end,
	},
	{
		"echasnovski/mini.jump",
		config = function()
			require("mini.jump").setup()
		end,
	},
	{
		"echasnovski/mini.jump2d",
		config = function()
			require("mini.jump2d").setup({
				mappings = {
					start_jumpings = "",
				},
			})
			vim.keymap.set(
				{ "n", "v" },
				"<CR>",
				':lua MiniJump2d.start(require("mini.jump2d").builtin_opts.single_character)<CR>'
			)
		end,
	},
	{
		"echasnovski/mini.misc",
		config = function()
			require("mini.misc").setup()
		end,
	},
	{
		"echasnovski/mini.pairs",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup({ n_lines = 42 })
		end,
	},
	"godlygeek/tabular",

	{
		"lalitmee/browse.nvim",
		config = function()
			local browse = require("browse")
			browse.setup({
				provider = "google", -- duckduckgo, bing
			})

			function Command(name, rhs, opts)
				opts = opts or {}
				vim.api.nvim_create_user_command(name, rhs, opts)
			end

			Command("Google", function()
				browse.input_search()
			end)

			Command("GitHubSearch", function()
				local github = {
					["Code"] = "https://github.com/search?q=%s&type=code",
					["Repo"] = "https://github.com/search?q=%s&type=repositories",
					["Issues"] = "https://github.com/search?q=%s&type=issues",
					["Pulls"] = "https://github.com/search?q=%s&type=pullrequests",
				}

				require("browse").open_bookmarks({ bookmarks = github, prompt_title = "Search Github" })
			end)
		end,
	},
}, {
	install = {
		colorscheme = { "rose-pine" },
	},
})
