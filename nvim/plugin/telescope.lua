local nmap = require('lib.util').nmap
local tel = require('lib.search').tel
local tel_act = require('lib.search').tel_act

function load_extension(name)
  if not pcall(require('telescope').load_extension, name) then
    vim.notify(
      "Tried to load '" .. name .. "' telescope extension but its not present on the system",
      vim.log.levels.WARN
    )
  end
end

--[[
--            -- special
            { "<leader><space>", tel("buffers", { show_all_buffers = true }), desc = "Switch buffer" },
            -- {"<leader>,", tel("find_files"), desc = "Find files (root dir)"},
            -- {"<leader>.", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser"},
            { "<leader>.",       tel("find_files", { cwd = true }),           desc = "File browser" },
            {"<leader>/", tel('current_buffer_fuzzy_find', { previewer = false }), desc = "Search in buffer"},
            {"<leader>;", tel("commands"), desc = "Search commands"},
            {"<leader>:", tel("command_history"), desc = "Command History"},
            {"<leader>'", tel("resume"), desc = "Command History"},
            -- files/find
            -- {"<leader>ff", tel("find_files", { cwd = false }), desc = "Find files (cwd)"},
            {"<leader>fr", tel("oldfiles"), desc = "Find recent files"},
            {"<leader>fg", tel("git_files"), desc = "Find git files"},
            -- search
            {"<leader>sg", tel("live_grep", { cwd = false }), desc = "Search in files (cwd)"},
            {"<leader>sG", tel("live_grep"), desc = "Search in files (root dir)"},
            -- help
            {"<leader>hh", tel("help_tags"), desc = "Search help pages"},
            {"<leader>ht", tel("colorscheme", { enable_preview = true, previewer = false }), desc = "Search colorscheme"},
            {"<leader>hm", tel("man_pages"), desc = "Search man pages"},
            { "<leader>hk",  tel("keymaps"),                            desc = "Keymaps" },
            -- --dev
            { "<leader>dd",  tel("diagnostics", { previewer = false }), desc = "Diagnostics" },
            { "<leader>da",  tel("actions", { previewer = false }),     desc = "Code actions" },
            { "<leader>ds",  tel("lsp_document_symbols"),               desc = "Goto symbol" },
            { "<leader>dws", tel("lsp_wokspace_symbols"),               desc = "Goto symbol" },
            {"gd", tel("lsp_definitions"), desc = "Goto definition"},
            {"gr", tel("lsp_references"), desc = "Goto references"},
--]]

-- [[ Telescope keymaps ]]
-- Files and buffers
nmap('<leader><leader>', tel('buffers', { show_all_buffers = true }), { desc = 'Switch buffers' })
nmap('<leader>,', tel('find_files'), { desc = 'Find files (root dir)' })
nmap('<leader>.', tel('find_files', { cwd = true }), { desc = 'Find files (cwd)' })
nmap('<leader>fr', tel('old_files', { cwd = true }), { desc = 'Find recent files' })
nmap('<leader>fg', tel('git_files', { cwd = true }), { desc = 'Find git files' })
-- Search
nmap('<leader>/', tel('current_buffer_fuzzy_find'), { desc = 'Find files (root dir)' })
nmap('<leader>sg', tel('live_grep', { cwd = false }), { desc = 'Grep files (cwd)' })
nmap('<leader>sG', tel('live_grep'), { desc = 'Grep files (root dir)' })
--help
nmap('<leader>hh', tel('help_tags'), { desc = 'Seach help pages' })
nmap('<leader>ht', tel('colorscheme', { enable_preview = true, previewer = false }), { desc = 'Search colorschemes' })
nmap('<leader>hm', tel('man_pages'), { desc = 'Search man pages' })
nmap('<leader>hk', tel('keymaps'), { desc = 'Search keymaps' })
-- commands
nmap('<leader>;', tel('commands'), { desc = 'Search commands' })
nmap('<leader>:', tel('command_history'), { desc = 'Command history' })
-- others
nmap("<leader>'", tel('resume'), { desc = 'Resume last search' })
-- lsp
nmap('gd', tel('lsp_definitions'), { desc = 'Go to definition' })
nmap('gr', tel('lsp_references'), { desc = 'Go to reference' })
nmap('gi', tel('lsp_implementations'), { desc = 'Go to implementation' })
nmap('<leader>ds', tel('lsp_document_symbols'), { desc = 'Search symbol in file' })
nmap('<leader>dws', tel('lsp_dynamic_workspace_symbols'), { desc = 'Search symbol in workspace' })
nmap('<leader>dd', tel('diagnostics'), { desc = 'Search Diagnostics' })

local opts = {
  defaults = {
    prompt_prefix = '::: ',
    selection_carret = ' ',
    mappings = {
      i = {
        ['<C-j>'] = 'move_selection_next',
        ['<C-k>'] = 'move_selection_previous',
        ['<C-l>'] = tel_act { 'send_to_qflist', 'open_qflist' },
        ['<C-c>'] = tel_act('close'),
      },
    },
    layout_strategy = 'bottom_pane',
    layout_config = {
      height = 20,
    },
    border = true,
    sorting_strategy = 'ascending',
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}

require('telescope').setup(opts)

-- Extensions
load_extension('fzf')
load_extension('ui-select')
