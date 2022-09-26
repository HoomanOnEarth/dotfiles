local ui = {}

function ui.plugins(use)
    use 'rose-pine/neovim'
end

function ui.setup()
    vim.opt.background = 'light'
    vim.cmd('colorscheme rose-pine')
end

return ui
