local keymap = require("utils.keymap")
local nmap = keymap.nmap
local imap = keymap.imap

local api = require('api.telescope-aerial')

require('aerial').setup {
    layout = {
        min_width = 10,
        max_width = { 40, 0.25 },
        default_direction = 'prefer_left'
    },
    on_attach = function(bufrn)
        nmap({ "<Leader>o", ":AerialToggle<Cr>" })
        nmap({ '<C-f>', api.outline })
    end
}

