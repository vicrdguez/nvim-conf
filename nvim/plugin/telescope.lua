local nmap = require('lib.util').nmap
local tel = require('lib.search').tel
local tel_act = require('lib.search').tel_act

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

opts = {
            defaults = {
                file_ignore_patterns = {
                    "^lazy-lock"
                },
                prompt_prefix = "::: ",
                selection_carret = ' ',
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<C-l>"] = tel_act({ "send_to_qflist", "open_qflist" }),
                        ["<C-c>"] = tel_act("close")
                    }
                },
                layout_strategy = "bottom_pane",
                layout_config = {
                    height = 20,
                },
                border = true,
                sorting_strategy = "ascending",
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        },
        config = function(_, opts)
            local telescope = require("telescope")
            -- setup telescope
            telescope.setup(opts)
            -- Load all extensions
            telescope.load_extension("ui-select")
            telescope.load_extension('fzf')
            telescope.load_extension('media_files')
            -- telescope.load_extension("file_browser")
        end
    },
--]]

nmap('<leader>,', tel('find_files'), { desc = 'Find files (root dir)' })
nmap('<leader>/', tel('current_buffer_fuzzy_find'), { desc = 'Find files (root dir)' })
nmap('<leader>sg', tel('live_grep', { cwd = false }), { desc = 'Grep files (cwd)' })

local opts = {
            defaults = {
                prompt_prefix = "::: ",
                selection_carret = ' ',
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<C-l>"] = tel_act({ "send_to_qflist", "open_qflist" }),
                        ["<C-c>"] = tel_act("close")
                    }
                },
                layout_strategy = "bottom_pane",
                layout_config = {
                    height = 20,
                },
                border = true,
                sorting_strategy = "ascending",
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        }

require('telescope').setup(opts)
-- Extensions
if not pcall(require('telescope').load_extension, 'fzf') then
    vim.notify("Tried to load 'fzf' telescope extension but its not present on the system", vim.log.levels.WARN)
end
if not pcall(require('telescope').load_extension, 'ui-select') then
    vim.notify("Tried to load 'ui-select' telescope extension but its not present on the system", vim.log.levels.WARN)
end

