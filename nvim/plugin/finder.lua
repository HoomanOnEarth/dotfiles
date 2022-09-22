if not pcall(require, "telescope") then
    print "telescope.nvim not found"
    return
end

local telescope = require "telescope"
local action_layout = require "telescope.actions.layout"
local previewers = require "telescope.previewers"
local themes = require('telescope.themes')
local ivy_theme_config = { sorting_strategy = 'ascending', prompt_position = 'bottom' }
local default_opts = themes.get_ivy(ivy_theme_config)

telescope.setup {
    defaults = vim.tbl_deep_extend("force", {
        preview = {
            hide_on_startup = true
        },
        mappings = {
            i = {
                ["<C-x>"] =  false,
                ["<C-h>"] = action_layout.toggle_preview,
                ["<M-m>"] = action_layout.toggle_mirror,
            },
        },
        buffer_previewer_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            filepath = vim.fn.expand(filepath)
            vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then return end
                if stat.size > 100000 then
                    return
                else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
            end)
        end,
    }, default_opts)
}

local keymap = require("utils.keymap")
local nmap = keymap.nmap
local imap = keymap.imap

local api = require('api.telescope')
imap({ '<C-c>', '<esc>' })
nmap({ '<Leader>dd', api.diagnostics })
nmap({ '<Leader>h', api.vim_help_tags })
nmap({ '<Leader>b', api.list_buffers })
nmap({ '<Leader>f', api.live_search })
nmap({ '<C-s>', api.current_buffer_search })
nmap({ '<C-p>', api.find_files })
nmap({ '<C-g>', api.change_project })
