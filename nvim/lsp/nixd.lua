local lsp_util = require('lspconfig.util')
local root_pattern = lsp_util.root_pattern(unpack {
  'flake.nix',
  'default.nix',
  'shell.nix',
  '.nixd.json',
})

return {
  root_dir = function(fname)
    return root_pattern(fname) or lsp_util.find_git_ancestor(fname)
  end,
  single_file_support = true,
}
