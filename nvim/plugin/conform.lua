local nmap = require('lib.util').nmap
local vars = require('vars')

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'nixpkgs_fmt' },
    yaml = { 'yamlfmt' },
    go = {'gofmt'},
  },
  formatters = {
    ['google-java-format'] = {
      command = vars.google_java_format,
    },
  },
}

-- Adding conform formatexpr, see :help formatexpr
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Adding the format keymap here for files that have formatter but no lsp configured
nmap('<leader>df', require('conform').format, { desc = 'Format buffer' })
