local keymap = require("utils.keymap")
local buf_nnoremap = keymap.buf_nnoremap
local buf_inoremap = keymap.buf_inoremap

local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
    return
end

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "tsserver" }
})

local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local custom_attach = function(client, bufnr)
    buf_inoremap { "<C-s>", vim.lsp.buf.signature_help }

    buf_nnoremap { "<leader>rr", "LspRestart<CR>" }
    buf_nnoremap { "<leader>rn", vim.lsp.buf.rename }
    buf_nnoremap { "<leader>ca", vim.lsp.buf.code_action }
    buf_nnoremap { "<M-p>", vim.lsp.diagnostic.goto_prev }
    buf_nnoremap { "<M-n>", vim.lsp.diagnostic.goto_next }

    buf_nnoremap { "K", vim.lsp.buf.hover }
    buf_nnoremap { "gd", vim.lsp.buf.definition }
    buf_nnoremap { "gD", vim.lsp.buf.declaration }
    buf_nnoremap { "gT", vim.lsp.buf.type_definition }

    require('aerial').on_attach(client, bufnr)
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
    tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
    }
}

local setup_server = function(server, config)
    if not config then
        return
    end

    if type(config) ~= "table" then
        config = {}
    end

    config = vim.tbl_deep_extend("force", {
        on_init = custom_init,
        on_attach = custom_attach,
        capabilities = updated_capabilities,
        flags = {
            debounce_text_changes = nil,
        },
    }, config)

    lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
    setup_server(server, config)
end
