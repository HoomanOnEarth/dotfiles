local lua = {}

function lua.plugins(use)
    --use({ "nvim-treesitter/tree-sitter-query", run = ":TSInstall query" })
end

function lua.setup()
    require("lspconfig").sumneko_lua.setup({
        on_attach = require("me.lsp").on_attach,
    })

    local null_ls = require("null-ls")
    null_ls.register(null_ls.builtins.formatting.stylua)
end

return lua
