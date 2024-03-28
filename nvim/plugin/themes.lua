local opts = {
     transparent = false,
     keywordStyle = { italic = false },
     overrides = function(colors)
         local col = colors.palette
         return {
             -- NormalFloat = { bg = "none" },
             FloatBorder            = { bg = "none" },
             FloatTitle             = { bg = "none" },
             -- Save an hlgroup with dark background and dimmed foreground
             -- so that you can use it where your still want darker windows.
             -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
             -- NormalDark = { fg = col.oldWhite, bg = col.sumiInk0 },

             -- more uniform colors for the popup menu
             -- Pmenu = { fg = theme.ui.shade0, bg = col.sumiInk4 }, -- add `blend = vim.o.pumblend` to enable transparency
             -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
             -- PmenuSbar              = { bg = col.sumiInk2 },
             -- PmenuThumb = { bg = theme.ui.bg_p2 },
             -- Popular plugins that open floats will link to NormalFloat by default;
             -- set their background accordingly if you wish to keep them dark and borderless
             -- NormalFloat            = { bg = col.sumiInk0, fg = col.oldWhite, blend = 0 },
             LazyNormal             = { bg = col.sumiInk0, fg = col.oldWhite },
             MasonNormal            = { bg = col.sumiInk0, fg = col.oldWhite },

             -- Diagnostics and Line number columns
             SignColumn             = { bg = col.sumiInk1 },
             LineNr                 = { bg = col.sumiInk1 },
             DiagnosticSignWarn     = { bg = "none" },
             DiagnosticSignInfo     = { bg = "none" },
             DiagnosticSignError    = { bg = "none" },
             DiagnosticSignHint     = { bg = col.sumiInk1 },

             -- trouble
             TroubleNormal          = { bg = col.sumiInk1 },
             TroubleFoldIcon        = { bg = col.sumiInk1 },
             TroubleLocation        = { bg = "none" },
             -- TroubleText     = { bg = "none" },
             -- NoiceCmdline      = { bg = col.sumiInk3, fg = col.sumiInk3 },
             NoiceCmdlineIcon       = { bg = col.sumiInk1, fg = col.dragonBlue },

             -- TelescopeTitle         = { bg = col.sumiInk2, fg = col.dragonBlue, bold = true },
             -- TelescopePromptNormal  = { bg = col.sumiInk2, fg = col.dragonBlue, bold = true },
             -- TelescopeResultsNormal = { bg = col.sumiInk2, fg = col.fujiWhite },
             -- TelescopePromptBorder  = { bg = col.sumiInk2, fg = col.sumiInk2 },
             -- TelescopeResultsBorder = { bg = col.sumiInk2, fg = col.sumiInk2, },
             -- TelescopePreviewNormal = { bg = col.sumiInk0 },
             -- TelescopePreviewBorder = { bg = col.sumiInk0, fg = col.sumiInk0 },

	     MiniStatuslineModeNormal = { bg = col.dragonYellow, fg = col.dragonBlack3 },
	     MiniStatuslineModeInsert = { bg = col.dragonGrey, fg = col.dragonBlack3 },
	     MiniStatuslineModeVisual = { bg = col.dragonGreen, fg = col.dragonBlack3 },
	     MiniStatuslineModeReplace = { bg = col.dragonPink, fg = col.dragonBlack3 },

             FzfLuaTitle            = { fg = col.springViolet1, bold = true },
             FzfLuaNormal           = { fg = col.oldWhite, bg = col.sumiInk2 },
             FzfLuaBorder           = { fg = col.sumiInk2, bg = col.sumiInk2 },
             FzfLuaCursor           = { bg = col.sumiInk4 },
             FzfLuaHelpNormal       = { bg = col.sumiInk1 },
             FzfLuaHelpBorder       = { bg = col.sumiInk1, fg = col.sumiInk1 },
             FzfLuaPreviewNormal    = { bg = col.sumiInk0 },

             -- mardkdown
             markdownBold           = { fg = col.waveAqua2 },
             markdownBoldItalic     = { fg = col.waveAqua2 },
        }
end
}
require('kanagawa').setup(opts)
vim.cmd('colorscheme kanagawa-dragon')


