require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}

require'treesitter-context'.setup {
    enable = true,
    max_lines = 0,
    trim_scope = 'outer',
    min_window_height = 0,
    patterns = { 
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
        },
        rust = {
            'impl_item',
            'struct',
            'enum',
        },
        markdown = {
            'section',
        },
        json = {
            'pair',
        },
        yaml = {
            'block_mapping_pair',
        },
    }
}
