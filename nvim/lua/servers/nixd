-- Exit if the language server isn't available
local lib = require('lib.lsp')
if not lib.is_ls_present('nixd') then return end
local lsp_util = require('lspconfig.util')

local root_pattern = lsp_util.root_pattern(unpack {
    'flake.nix',
    'default.nix',
    'shell.nix',
    '.nixd.json'
})



require('lspconfig').nixd.setup {
    root_dir = function(fname)
        return root_pattern(fname) or lsp_util.find_git_ancestor(fname)
    end,
    single_file_support = true,
}
