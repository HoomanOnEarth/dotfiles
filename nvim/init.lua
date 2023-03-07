local all_modes = { "n", "v", "x" }
local map = vim.keymap.set
local auto_cmd = vim.api.nvim_create_autocmd

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

vim.o.updatetime = 450
vim.o.timeout = true
vim.o.timeoutlen = 420
vim.o.completeopt = "menuone,noselect"

vim.cmd([[
	cab Q q!
	cab Qa qa!
	cab W w!
	cab Wq wq!

	nnoremap <C-s> :w!<CR>
	inoremap jj <ESC>

	augroup SmartCursorLine
		au!
		au InsertLeave,WinEnter * set cursorline
		au InsertEnter,WinLeave * set nocursorline
	augroup END

	augroup SmartNumbers
		au!
		au FocusGained,InsertLeave,BufEnter &buftype ==# "terminal"  set relativenumber
		au FocusLost,InsertEnter,BufLeave &buftype ==# "terminal" set norelativenumber
	augroup END

	augroup CursorHoldHints
		au!			
		au CursorHold * lua vim.diagnostic.open_float()
		au CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
	augroup END

	augroup Utilities
		au!
		au BufEnter * set formatoptions-=cro
	augroup END

	au BufWinEnter ~/code/scripts/* if &ft == "" | setlocal ft=sh | endif
	au BufWritePost * if &ft == "sh" | silent! execute "!chmod +x %" | endif
]])

auto_cmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.js", "*.html", "*.css" },
	callback = function()
		vim.o.tabstop = 2
		vim.o.softtabstop = 2
		vim.o.shiftwidth = 2

		vim.g.html_indent_style1 = "inc"
		vim.g.html_indent_script1 = "inc"
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
	-- Tmux plugins
	{
		"christoomey/vim-tmux-navigator",
		init = function()
			vim.cmd([[
				let g:tmux_navigator_disable_when_zoomed = 1
				let g:tmux_navigator_no_mappings = 1
			]])
		end,
		config = function()
			vim.cmd([[
				nnoremap <silent> <C-h> <Cmd>TmuxNavigateLeft<CR>
				nnoremap <silent> <C-j> <Cmd>TmuxNavigateDown<CR>
				nnoremap <silent> <C-k> <Cmd>TmuxNavigateUp<CR>
				nnoremap <silent> <C-l> <Cmd>TmuxNavigateRight<CR>
				nnoremap <silent> <C-\> <Cmd>TmuxNavigatePrevious<CR>
			]])
		end,
	},

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
				open_mapping = "<M-`>",
				direction = "vertical",
				size = 80,
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				map("t", "<ESC>", [[<C-\><C-n>]], opts)
				map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd TermOpen term://* lua set_terminal_keymaps()")
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

			map("n", "K", require("ufo").peekFoldedLinesUnderCursor, { noremap = true })
			map(all_modes, "zR", require("ufo").openAllFolds)
			map(all_modes, "zM", require("ufo").closeAllFolds)
			map(all_modes, "zr", require("ufo").openFoldsExceptKinds)
			map(all_modes, "zm", function()
				vim.ui.input({
					prompt = "Fold to level: ",
					default = 0,
				}, function(level)
					require("ufo").closeFoldsWith(tonumber(level))
				end)
			end)

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

			map("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true })
		end,
	},

	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = false,
					underline = true,
					signs = true,
				})

			local servers = {
				rust_analyzer = {},
				tsserver = {},
				html = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			}

			local function on_attach(client, bufnr)
				-- setters
				local buf_set_option = function(...)
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				-- disable LSP highlight
				client.server_capabilities.semanticTokensProvider = nil

				map("n", "<leader>rr", ":LspRestart<CR>", { desc = "Restart LSP servers" })
				map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP hover" })
				map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
				map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })
				map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code actions" })

				local ts = require("telescope.builtin")
				map("n", "gd", ts.lsp_definitions, { desc = "Goto definitions" })
				map("n", "gr", ts.lsp_references, { desc = "Goto references" })
				map("n", "gI", ts.lsp_implementations, { desc = "Goto implementations" })
				map("n", "gT", ts.lsp_type_definitions, { desc = "Goto type definitions" })
				map("n", "gs", ts.lsp_document_symbols, { desc = "List document symbols" })
				map("n", "gq", vim.lsp.buf.format, { desc = "LSP format" })

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			require("neodev").setup()
			require("mason").setup()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
			mason_lspconfig.setup_handlers({
				function(server_name)
					local opts = {
						on_attach = on_attach,
						capabilities = capabilities,
						settings = servers[server_name],
						init_options = {
							onlyAnalyzeProjectsWithOpenFiles = true,
							suggestFromUnimportedLibraries = false,
							closingLabels = true,
						},
					}

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

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
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
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
				},
				completion = {
					max_item_count = 8,
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
							["<M-p>"] = action_layout.toggle_preview,
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
			local ts = require("telescope.builtin")
			map("n", "<leader>?", ts.oldfiles, { desc = "Recent files" })
			map("n", "<leader><space>", ts.buffers, { desc = "Recent buffers" })
			map("n", "<C-p>", ts.find_files, { desc = "Browse files" })
			map("n", "<leader>sh", ts.help_tags, { desc = "Search helps" })
			map("n", "<leader>sf", ts.live_grep, { desc = "Live search" })
			map("n", "<leader>sw", ts.grep_string, { desc = "Search" })
			map("n", "<leader>sd", ts.diagnostics, { desc = "List diagnostics" })
			map("n", "<C-f>", ts.current_buffer_fuzzy_find, { desc = "Current file fuzzy search" })
			map("n", "<C-g>", require("api.telescope").change_directory, { desc = "Change directory" })
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

	-- Useful plugins
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
			map({ "n", "v" }, "<CR>", ':lua MiniJump2d.start(require("mini.jump2d").builtin_opts.single_character)<CR>')
		end,
	},
	{
		"echasnovski/mini.misc",
		config = function()
			require("mini.misc").setup()
			require("mini.misc").setup_restore_cursor()
		end,
	},
	{
		"lalitmee/browse.nvim",
		config = function()
			local browse = require("browse")
			browse.setup({
				provider = "google", -- duckduckgo, bing
			})

			vim.api.nvim_create_user_command("Google", function()
				browse.input_search()
			end, {})

			vim.api.nvim_create_user_command("GitHubSearch", function()
				local github = {
					["Code"] = "https://github.com/search?q=%s&type=code",
					["Repo"] = "https://github.com/search?q=%s&type=repositories",
					["Issues"] = "https://github.com/search?q=%s&type=issues",
					["Pulls"] = "https://github.com/search?q=%s&type=pullrequests",
				}

				require("browse").open_bookmarks({ bookmarks = github, prompt_title = "Search Github" })
			end, {})
		end,
	},
}, {
	install = {
		colorscheme = { "rose-pine" },
	},
})

-- Key mappings
map({ "n" }, "<leader>cd>", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change directory" })
map({ "n" }, "<leader>l", ":nohl<CR>", { desc = "Clear highlights" })
map({ "x" }, "<leader>l", ":nohl<CR>", { desc = "Clear highlights" })

map("n", "k", 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true, desc = "Better moving between lines" })
map("n", "j", 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true, desc = "Better moving between lines" })

-- diagnostic
map("n", "g[", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "g]", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", function()
	vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "Hover diagnostic under cursor" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "List diagnostics in quickfixlist" })

map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

map(
	"n",
	"<leader>m",
	":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
	{ desc = "Quickly create & edit macro" }
)
