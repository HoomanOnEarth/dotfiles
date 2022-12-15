local syntax = {}

function syntax.plugins(use)
    use("sheerun/vim-polyglot")
    --use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    --use("nvim-treesitter/nvim-treesitter-textobjects")
    --use("nvim-treesitter/playground")
end

function syntax.setup()
    --require("nvim-treesitter.configs").setup({
    --    indent = {
    --        enable = true,
    --        disable = { "liquid" },
    --    },
    --    highlight = {
    --        enable = false,
    --        additional_vim_regex_highlighting = true,
    --        disable = function(lang, buf)
    --            if lang == "liquid" then
    --                return false
    --            end

    --            local max_filesize = 100 * 1024 -- 100 KB
    --            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --            if ok and stats and stats.size > max_filesize then
    --                return true
    --            end
    --        end,
    --    },
    --    textobjects = {
    --        select = {
    --            enable = true,
    --            lookahead = true,
    --            keymaps = {
    --                ["af"] = "@function.outer",
    --                ["if"] = "@function.inner",
    --                ["ip"] = "@parameter.inner",
    --                ["ap"] = "@parameter.outer",
    --            },
    --        },
    --    },
    --})

    --vim.opt.foldmethod = "expr"
    --vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    --vim.opt.foldlevel = 99
end

return syntax
