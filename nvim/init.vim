set shada=!,'1000,<50,s10,h
set clipboard+=unnamedplus

set nowrap
set scrolloff=4
set number
set relativenumber
set signcolumn=yes
set splitbelow
set splitright
set inccommand=split

" searching settings
set ignorecase	" ignore case when searching...
set smartcase 	" but be smart when I use capital letter

" default tab & spaces size - option 2
set tabstop=4
set shiftwidth=4
set expandtab

let mapleader="\<Space>"
nmap <Leader><CR> :source %<CR>

call plug#begin()
Plug 'rose-pine/neovim', { 'as': 'rose-pine', 'tag': 'v1.*' }

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' 
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

Plug 'mbbill/undotree'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'tpope/vim-liquid'
Plug 'airblade/vim-gitgutter'
Plug 'stevearc/aerial.nvim'
call plug#end()

set background=light
colorscheme rose-pine
