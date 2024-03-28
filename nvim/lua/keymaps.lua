-- [[ General keymaps, not specific to any plugin ]] 
local nmap = require("lib.util").nmap

-- Confy buffer movements
nmap('<C-h>', '<C-w><C-h>', { desc = 'Ez move to the left buffer' })
nmap('<C-l>', '<C-w><C-l>', { desc = 'Ez move to the right buffer' })
nmap('<C-j>', '<C-w><C-j>', { desc = 'Ez move to the lower buffer' })
nmap('<C-k>', '<C-w><C-k>', { desc = 'Ez move to the upper buffer' })
