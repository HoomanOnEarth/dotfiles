local system = {}

function system.plugins(use)
    use 'nvim-lua/plenary.nvim'
end

function system.bindings(map)
    map("i", "<C-c>", "<ESC>", {})
end

return system
