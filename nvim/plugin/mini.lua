-- [[ Mini statusline]]
-- Simple statusline, might change to something fancier in the future
-- Replace by heirline for now
-- local statusline = require('mini.statusline')

-- local function filename_section(args)
--     if vim.bo.buftype == 'terminal' then
--         return '%t'
--     elseif statusline.is_truncated(args.trunc_width) then
--         return '%f%m%r'
--     else
--         return '%t%m%r'
--     end
-- end

-- statusline.setup { use_icons = true }
-- statusline.section_filename = filename_section

-- [[ Mini AI ]]
-- Better arround/inside navigation
require('mini.ai').setup { n_lines = 500 }

-- [[ Mini surround ]]
-- Manipulate surround characters on selected text (quotes, brackets, etc...)
require('mini.surround').setup {}

-- [[ Mini comment ]]
-- gc(c) for commenting code
require('mini.comment').setup {}

-- [[ Mini jump ]]
-- Improves f,F,t and T jumps
require('mini.jump').setup {}

-- [[ Mini splitjoin ]]
-- Join args and lists, or split them with gS
require('mini.splitjoin').setup {}

-- [[ Mini pairs ]]
-- Auto-match charachter pairs
require('mini.pairs').setup {}

-- [[ Mini hipatterns ]]
-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE' comments
require('mini.hipatterns').setup({
    highlighters = {
        fixme     = {
            pattern = '%f[%w]()FIXME()%f[%W]',
            group = 'MiniHipatternsFixme'
        },
        hack      = {
            pattern = '%f[%w]()HACK()%f[%W]',
            group = 'MiniHipatternsHack'
        },
        todo      = {
            pattern = '%f[%w]()TODO()%f[%W]',
            group = 'MiniHipatternsTodo'
        },
        note      = {
            pattern = '%f[%w]()NOTE()%f[%W]',
            group = 'MiniHipatternsNote'
        },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
})
