require('nvim-treesitter.configs').setup {
    -- All grammars are alredy installed by nix
    auto_install = false,
    highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        -- If you are experiencing weird indenting issues, add the language to
        -- the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = {
        enable = true,
        -- Following the example above
        disable = { 'ruby' }
    },
}
