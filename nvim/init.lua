-- essentials
vim.cmd([[
colorscheme quiet
let g:mapleader = " "
let g:maplocalleader = " "

" use ripgrep
set grepprg="rg --vimgrep --smart-case"
set grepformat=%f:%l:%c:%m,%f:%l:%m

cabbrev Q q!
cabbrev Qa qa!
cabbrev W w!
cabbrev Wq wq!
cabbrev Wqa wqa!

noremap   <silent> <leader>l :nohl<CR>
nnoremap  <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>

vnoremap < <gv
vnoremap > >gv

" dont move
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" chmod +x
nnoremap <leader>x :silent !chmod +x %<CR>

" jumps
nnoremap gi gi<ESC>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <C-k> :cnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
nnoremap <leader>k :cnext<CR>zz

" moving line
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" diagnostics
nnoremap <C-j> :lua vim.diagnostic.goto_prev()<CR>
nnoremap <C-k> :lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>q :lua vim.diagnostic.setloclist()<CR>
nnoremap <leader>e :lua vim.diagnostic.open_float(nil, { focus = false })<CR>
]])

-- options
vim.cmd([[
set mouse=a
set number
set relativenumber
set termguicolors
set clipboard=unnamedplus
set statusline="2"
set signcolumn=yes

set wrap
set linebreak
set splitright

set autoindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set complete-=ti

set incsearch
set ignorecase
set smartcase

set whichwrap="b,s,<,>,h,l,[,]"

augroup c_language_autocmd
  autocmd! BufEnter *.c set makeprg=clang\ -Wall\ %\ -o\ %:r"
augroup END

function DiffModeMap()
  if &diff
    nnoremap gf <buffer> <cmd>diffget //2<CR> " get the left side
    nnoremap gh <buffer> <cmd>diffget //3<CR> " get the right side
  endif
endfunction

augroup fugitive_mapping_autocmd
  autocmd!
  autocmd BufEnter * call DiffModeMap()
augroup END


augroup cursor_hold_hints_autocmd
  autocmd! CursorHold * lua vim.diagnostic.open_float({ scope = "cursor", focus = false })
  autocmd! CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END

" auto chmod my scripts
augroup chmod_my_script_autocmd
  autocmd! BufWinEnter ~/code/scripts/* if &ft == "" | setlocal ft=sh | endif
  autocmd! BufWritePost * if &ft == "sh" | silent! execute "!chmod +x %" | endif
augroup END
]])

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

local auto_cmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
---@diagnostic disable-next-line: unused-local
local all_modes = { "n", "v", "x" }

-- editor config for common file types
auto_cmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.liquid" },
	callback = function(ev)
		vim.o.tabstop = 2
		vim.o.softtabstop = 2
		vim.o.shiftwidth = 2

		vim.g.html_indent_style1 = "inc"
		vim.g.html_indent_script1 = "inc"
	end,
})

-- Enable Formatter
auto_cmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.liquid", "*.c", "*.rs" },
	callback = function()
		map("n", "gq", ":Format<CR>", { desc = "Formatter format" })
	end,
})

require("lazy").setup({
	{ "tpope/vim-fugitive", config = function() end },
	{ "tpope/vim-liquid", config = function() end },
	{ "tpope/vim-markdown", config = function() end },
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
      nnoremap <silent> <C-b> :TmuxNavigatePrevious<CR>
      ]])
		end,
	},
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			vim.o.background = "light"
			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- Finder
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
				defaults = vim.tbl_deep_extend("force", default_opts, {
					preview = {
						hide_on_startup = true,
					},
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
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
				}),
			})

			local ts = require("telescope.builtin")
			map("n", "<leader>?", ts.oldfiles, { desc = "Recent files" })
			map("n", "<leader><space>", ts.buffers, { desc = "Recent buffers" })
			map("n", "<C-p>", ts.find_files, { desc = "Browse files" })
			map("n", "<leader>sh", ts.help_tags, { desc = "Search helps" })
			map("n", "<leader>sf", ts.live_grep, { desc = "Live search" })
			map("n", "<leader>sw", ts.grep_string, { desc = "Search" })
			map("n", "<leader>sd", ts.diagnostics, { desc = "List diagnostics" })
			map("n", "<leader>qf", vim.diagnostic.setqflist, { desc = "List diagnostics" })
			map("n", "<C-f>", ts.current_buffer_fuzzy_find, { desc = "Current file fuzzy search" })
			map("n", "<C-g>", require("api.telescope").change_directory, { desc = "Change directory" })
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

	-- Syntax
  { "pangloss/vim-javascript" },
	{ "MaxMEllon/vim-jsx-pretty" },

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
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").load({
				include = {
					"all",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"liquid",
					"markdown",
					"c",
					"rust",
				},
			})
			luasnip.filetype_set("javascript", { "javascriptreact" })
			luasnip.filetype_set("typescript", { "typescriptreact" })

			local cmp = require("cmp")
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			---@diagnostic disable-next-line: missing-fields
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
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						elseif fallback then
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						elseif fallback then
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
				},
				---@diagnostic disable-next-line: missing-fields
				completion = {
					max_item_count = 8,
					keyword_length = 2,
				},
			})
		end,
	},

	-- Formatter
	{
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.INFO,
				filetype = {
					c = {
						require("formatter.filetypes.c").clangformat,
					},
					json = {
						require("formatter.filetypes.json").prettierd,
					},
					jsonc = {
						require("formatter.filetypes.json").prettierd,
					},
					css = {
						require("formatter.filetypes.css").prettierd,
					},
					html = {
						require("formatter.filetypes.html").prettierd,
					},
					javascript = {
						require("formatter.filetypes.javascript").eslint_d,
					},
					javascriptreact = {
						require("formatter.filetypes.javascriptreact").eslint_d,
					},
					typescript = {
						require("formatter.filetypes.typescript").eslint_d,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").eslint_d,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					rust = {
						require("formatter.filetypes.rust").rustfmt,
					},
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("neodev").setup()

			-- lsp diagnostics
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = false,
					underline = true,
					signs = true,
				})

			-- setup to use with diagnostics
			function SignatureFixed()
				vim.api.nvim_command("set eventignore=CursorHold")
				vim.lsp.buf.signature_help()
				vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
			end

			function HoverFixed()
				vim.api.nvim_command("set eventignore=CursorHold")
				vim.lsp.buf.hover()
				vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
			end

			local function on_attach(client, bufnr)
				-- helpers
				local buf_set_option = function(...)
					---@diagnostic disable-next-line: redundant-parameter
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

				-- disable LSP highlight
				client.server_capabilities.semanticTokensProvider = false

				map("i", "<C-k>", SignatureFixed, { desc = "LSP hover" })
				map("n", "K", HoverFixed, { desc = "LSP hover" })
				map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })
				map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code actions" })

				map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz", { desc = "Goto definitions" })
				map("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>zz", { desc = "Goto type definitions" })
				map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", { desc = "Goto implementations" })

				local telescope_builtin = require("telescope.builtin")
				map("n", "gr", telescope_builtin.lsp_references, { desc = "Goto references" })
				map("n", "gs", telescope_builtin.lsp_document_symbols, { desc = "List document symbols" })
			end

			local servers_settings = {
				tsserver = {
					diagnostics = {
						ignoredCodes = {
							7016,
							80001,
							80002, -- This constructor function may be converted to a class declaration.
						},
					},
					typescript = {
						format = {
							indentSize = 2,
							semicolons = "ignore",
							convertTabsToSpaces = true,
							indentStyle = "Smart",
							trimTrailingWhitespace = true,
						},
					},
					javascript = {
						format = {
							indentSize = 2,
							semicolons = "ignore",
							convertTabsToSpaces = true,
							indentStyle = "Smart",
							trimTrailingWhitespace = true,
						},
					},
				},
				lua_ls = {
					Lua = {
						format = {
							enable = false,
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				emmet_language_server = {
					filetypes = {
						"css",
						"html",
						"liquid",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					init_options = {
						preferences = {},
						showexpandedabbreviation = "always",
						showabbreviationsuggestions = true,
						showsuggestionsassnippets = false,
						syntaxprofiles = {},
						variables = {},
						excludelanguages = {},
					},
				},
			}

			require("mason").setup()
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers_settings) })
			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = servers_settings[server_name],
					})
				end,
			})

			require("lspconfig").clangd.setup({
				cmd = { "clangd" },
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Swift
			-- require("lspconfig").sourcekit.setup({
			--   on_attach = on_attach,
			--   capabilities = capabilities,
			-- })
		end,
	},

	-- Miscs
	{
		"phaazon/hop.nvim",
		config = function()
			local hop = require("hop")
			hop.setup()

			map("", "gw", hop.hint_words)
		end,
	},

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

	-- Apple
	-- {
	--   'xbase-lab/xbase',
	--   run = 'make install', -- or "make install && make free_space" (not recommended, longer build time)
	--   dependencies = {
	--     "neovim/nvim-lspconfig",
	--   },
	--   config = function()
	--     require 'xbase'.setup({
	--       log_level = vim.log.levels.INFO,
	--       log_buffer = {
	--         focus             = false,
	--         default_direction = "vertical",
	--       },
	--     }) -- see default configuration bellow
	--   end
	-- }
}, { install = { colorscheme = { "rose-pine" } } })
