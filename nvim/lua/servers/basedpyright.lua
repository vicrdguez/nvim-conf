local lib = require('lib.lsp')
if not lib.is_ls_present('basedpyright') then
  return
end

require('lspconfig').basedpyright.setup {}
