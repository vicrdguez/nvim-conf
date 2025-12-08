local lib = require('lib.lsp')
if not lib.is_ls_present('expert') then
  return
end

require('lspconfig').expert.setup {}
