local lib = require('lib.lsp')
if not lib.is_ls_present('harper-ls') then
  return
end
--

local custom_filetypes = {
  'markdown',
  'rust',
  'typescript',
  'typescriptreact',
  'javascript',
  'python',
  'go',
  'c',
  'cpp',
  'ruby',
  'swift',
  'csharp',
  'toml',
  'lua',
  'gitcommit',
  'java',
  'html',
  -- 'typst',
}
--
require('lspconfig').harper_ls.setup {
  filetypes = custom_filetypes,
  settings = {
    ['harper-ls'] = {
      codeActions = {
        forceStable = true,
      },
      linters = {
        spell_check = true,
        spelled_numbers = false,
        an_a = true,
        sentence_capitalization = true,
        unclosed_quotes = true,
        wrong_quotes = false,
        long_sentences = true,
        repeated_words = true,
        spaces = true,
        matcher = true,
        correct_number_suffix = true,
        number_suffix_capitalization = true,
        multiple_sequential_pronouns = true,
        linking_verbs = false,
        avoid_curses = true,
        terminating_conjunctions = true,
      },
    },
  },
}
