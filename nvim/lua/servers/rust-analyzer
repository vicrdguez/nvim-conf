local lib = require('lib.lsp')
if not lib.is_ls_present('rust-analyzer') then
  return
end

require('lspconfig').rust_analyzer.setup {
  on_attach = function(_, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
  settings = {
    ['rust_analyzer'] = {
      cargo = {
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
        allFeatures = true,
      },
      checkOnSave = {
        allFeatures = true,
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      check = {
        command = 'clippy',
        features = 'all',
        -- extraArgs = { '--no-deps' },
      },
      diagnostics = {
        enable = true,
      },
      -- cargo = {
      --   allFeatures = true,
      -- },
      -- -- Add clippy lints for rust
      -- check = {
      --   overrideCommand = 'clippy',
      --   extraArgs = {
      --     '--',
      --     '--no-deps',
      --     '-Dclippy::correctness',
      --     '-Dclippy::complexity',
      --     '-Wclippy::perf',
      --     '-Wclippy::pedantic',
      --   },
      -- },
    },
  },
}
