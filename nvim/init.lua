-- essentials
vim.cmd [[
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
noremap   <silent> <C-c> <ESC>
nnoremap  <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>

" moving line
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" diagnostics
nnoremap g[ :lua vim.diagnostic.goto_prev()<CR>
nnoremap g] :lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>q :lua vim.diagnostic.setloclist()<CR>
nnoremap <leader>e :lua vim.diagnostic.open_float(nil, { focus = false })<CR>
]]

-- options
vim.cmd [[
set mouse=a
set number
set relativenumber
set termguicolors
set clipboard=unnamedplus
set statusline="2"
set signcolumn=yes

set nowrap
set splitright
set splitbelow

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

augroup Utilities
  autocmd! BufEnter * set formatoptions-=cro
augroup END

augroup CursorHoldHints
  autocmd! CursorHold * lua vim.diagnostic.open_float({ scope = "cursor" })
  autocmd! CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END

" auto chmod my scripts
autocmd! BufWinEnter ~/code/scripts/* if &ft == "" | setlocal ft=sh | endif
autocmd! BufWritePost * if &ft == "sh" | silent! execute "!chmod +x %" | endif

" auto refresh quickfix: InsertLeave, BufWritePost
augroup SmartQfList
  function RefreshQuickfixList()
    let win_info = getwininfo()
    let quickfix_open = 0

    for info in win_info
      if info.quickfix
        let quickfix_open = 1
        break
      endif
    endfor

    if quickfix_open == 1
      lua vim.diagnostic.setqflist()
    endif
  endfunction

  autocmd! InsertLeave,BufWritePost * call RefreshQuickfixList()
augroup END
]]

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
local all_modes = { "n", "v", "x" }

-- HTML CSS JS basic setup
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


require("lazy").setup({
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.cmd [[
      let g:tmux_navigator_disable_when_zoomed = 1
      let g:tmux_navigator_no_mappings = 1
      ]]
    end,
    config = function()
      vim.cmd [[
      nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
      nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
      nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
      nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
      nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>
      ]]
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
      map("n", "<leader>qf", vim.diagnostic.setqflist, { desc = "List diagnostics" })
      map("n", "<C-f>", ts.current_buffer_fuzzy_find, { desc = "Current file fuzzy search" })
      map("n", "<C-g>", require("api.telescope").change_directory, { desc = "Change directory" })
    end,
  },

  -- Syntax
  { "sheerun/vim-polyglot" },

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
      require("mason").setup()

      vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
            underline = true,
            signs = true,
          })

      local servers = {
        tsserver = {},
        lua_ls = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

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
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- disable LSP highlight
        client.server_capabilities.semanticTokensProvider = nil

        map("i", "<C-h>", SignatureFixed, { desc = "LSP hover" })
        map("n", "K", HoverFixed, { desc = "LSP hover" })
        map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })
        map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code actions" })

        local telescope_builtin = require("telescope.builtin")
        map("n", "gd", telescope_builtin.lsp_definitions, { desc = "Goto definitions" })
        map("n", "gr", telescope_builtin.lsp_references, { desc = "Goto references" })
        map("n", "gI", telescope_builtin.lsp_implementations, { desc = "Goto implementations" })
        map("n", "gT", telescope_builtin.lsp_type_definitions, { desc = "Goto type definitions" })
        map("n", "gs", telescope_builtin.lsp_document_symbols, { desc = "List document symbols" })
        map("n", "gq", vim.lsp.buf.format, { desc = "LSP format" })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

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
    end
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

}, { install = { colorscheme = { "rose-pine" } } })
