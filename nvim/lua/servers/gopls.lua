local lib = require('lib.lsp')
if not lib.is_ls_present('gopls') then
  return
end

require('lspconfig').gopls.setup {}
