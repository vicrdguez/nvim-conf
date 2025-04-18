local nmap = require('lib.util').nmap
local map = require('lib.util').map
local augroup = require('lib.util').augroup

local M = {}
local cache_vars = {}
local root_markers = { ".gradle", "gradlew", ".git", "pom.xml", "mvnw" }
-- File generated by the nix build, populated with path and other info we can gather from nipkgs
local vars = require('vars');
local home = os.getenv("HOME")
local cache_dir = home .. '/.cache'

local function get_jdtls_paths()
    if cache_vars.paths then
        return cache_vars.paths
    end

    local path = {}

    path.root_dir = require('jdtls.setup').find_root(root_markers)
    local project_name = vim.fn.fnamemodify(path.root_dir, ":p:h:t")
    path.workspace_dir = cache_dir .. "/jdtls/workspace/" .. project_name

    path.jdtls_bin = vars.jdtls_path .. "/bin/jdtls"
    path.launcher_jar = vim.fn.glob(vars.jdtls_path .. '/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')

    -- JDTLS config dir is not writable since its on the nix store. Copying it here to the
    -- cache dir so we can it can be writable and jdtls does not fail
    -- Creating the dir if does not exist
    path.platform_config = cache_dir .. '/jdtls/config'
    local ok, _, errcode = os.rename(path.platform_config, path.platform_config)

    if not ok then
        if errcode == 13 then
            vim.notify('Jdtls config dir: Permission denied')
        end
        vim.notify('jdtls config directory does not exist. Creating it')
        vim.fn.mkdir(path.platform_config, 'p')
    end

    if vim.fn.has('mac') == 1 then
        vim.fn.system({
            'cp',
            vars.jdtls_path .. '/share/java/jdtls/config_mac/config.ini',
            path.platform_config .. '/config.ini'
        })
    elseif vim.fn.has('unix') == 1 then
        vim.fn.system({
            'cp',
            vars.jdtls_path .. '/share/java/jdtls/config_linux/config.ini',
            path.platform_config .. '/config.ini'
        })
    end

    path.bundles = {}

    local java_debug_bundle = vim.split(vim.fn.glob(vars.java_debug_path .. "/*.jar"), "\n")
    local java_test_bundle = vim.split(vim.fn.glob(vars.java_test_path .. "/*.jar", true), "\n")

    -- add jars to the bundle list if there are any
    if java_debug_bundle[1] ~= "" then
        vim.list_extend(path.bundles, java_debug_bundle)
    end

    if java_test_bundle[1] ~= "" then
        vim.list_extend(path.bundles, java_test_bundle)
    end

    path.runtimes = {
        {
            name = "JavaSE-11",
            path = vars.java_11_path,
        },
        {
            name = "JavaSE-17",
            path = vars.java_17_path,
        },
        {
            name = "JavaSE-21",
            path = vars.java_21_path,
            default = true,
        },
    }

    cache_vars.paths = path

    return path
end

local function get_jdtls_capabilities(jdtls)
    if cache_vars.capabilities and cache_vars.capabilities then
        return cache_vars.capabilities, cache_vars.extended_capabilities
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace.configuration = true
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local extended_capabilities = jdtls.extendedClientCapabilities
    extended_capabilities.resolveAdditionalTextEditsSupport = true

    local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        ok_cmp and cmp_lsp.default_capabilities() or {}
    )
    cache_vars.extended_capabilities = extended_capabilities
    cache_vars.capabilities = capabilities

    return capabilities, extended_capabilities
end

local function enable_codelens(bufnr)
    pcall(vim.lsp.codelens.refresh)

    vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = bufnr,
        group = augroup("jdtls"),
        desc = "Refresh codelens",
        callback = function()
            pcall(vim.lsp.codelens.refresh)
        end
    })
end

local function enable_debugger(_) -- param: bufnr
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
    vim.notify("Jdtls Debugger enbled")
end


local function jdtls_on_attach(_, bufnr) -- params: client, bufnr
    -- enable_debugger(bufnr)
    enable_codelens(bufnr)

    vim.notify("jdtls attached")

    local opts = { buffer = bufnr }
    nmap("<A-o>", require('jdtls').organize_imports, opts)
    nmap("crv", require('jdtls').extract_variable, opts)
    nmap("crc", require('jdtls').extract_constant, opts)
    map("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
    map("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
    map("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

M.jdtls_setup = function(_) -- param: event
    local jdtls = require("jdtls")
    local paths = get_jdtls_paths()


    local cmd = {
        vars.java_17_path .. "/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx4g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", paths.launcher_jar,
        "-configuration", paths.platform_config,
        "-data", paths.workspace_dir,
    }
  -- ./jdtls --java-executable /nix/store/q32388wcbqmrr7rbp9hl6sl3vlqagyzn-jdt-language-server-1.39.0/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar -data /Users/vrodriguez/.cache/jdtls/workspace/kafka-connect-explode-transform --jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1 --jvm-arg=-Dosgi.bundles.defaultStartLevel=4 --jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product --jvm-arg=-Dlog.protocol=true --jvm-arg=-Dlog.level=ALL --jvm-arg=-Xmx4g

    local bin_cmd = {
        paths.jdtls_bin,
        "--java-executable", paths.launcher_jar,
        "-data", paths.workspace_dir,
        "--jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "--jvm-arg=-Dosgi.bundles.defaultStartLevel=4",
        "--jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product",
        "--jvm-arg=-Dlog.protocol=true",
        "--jvm-arg=-Dlog.level=ALL",
        "--jvm-arg=-Xmx4g",
    }


    vim.notify(table.concat(cmd, " "))
    vim.notify(table.concat(bin_cmd, " "))

    local capabilities, extended_capabilities = get_jdtls_capabilities(jdtls)

    local lsp_settings = {
        java = {
            jdt = {
                ls = {
                    -- vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
                    java = {
                        home = vars.java_21_path,
                    }
                }
            },
            signatureHelp = { enabled = true },
            referencesCodeLens = { enabled = true },
            implementationCodeLens = { enabled = true },
            inlayHints = {
                parameterNames = {
                    enabled = "all" -- literals, all, none
                },
            },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.junit.Assume.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.junit.jupiter.api.Assumptions.*",
                    "org.junit.jupiter.api.DynamicContainer.*",
                    "org.junit.jupiter.api.DynamicTest.*",
                },
                filteredTypes = {
                    "org.junit.Assert.*",
                    "org.junit.Assume.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.junit.jupiter.api.Assumptions.*",
                    "org.junit.jupiter.api.DynamicContainer.*",
                    "org.junit.jupiter.api.DynamicTest.*",
                },
            },
            sources = {
                organizeImports = {
                    startThreshold = 9999,
                    stasticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
                generateComments = true,
            },
            format = {
                settings = {
                    url = vars.google_java_style,
                    profile = "GoogleStyle",
                },
            },
            contentProvider = {
                preferred = "fernflower"
            },
            extendedClientCapabilities = extended_capabilities,
            import = {
                gradle = {
                    enabled = true,
                    wrapper = { enabled = true },
                },
                maven = { enabled = true },
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = paths.runtimes,
            },
        },
    }

    jdtls.start_or_attach({
        cmd = bin_cmd,
        settings = lsp_settings,
        on_attach = jdtls_on_attach(),
        capabilities = capabilities,
        root_dir = paths.root_dir,
        flags = {
            allow_incremental_sync = true,
        },
        init_options = {
            bundles = paths.bundles,
            extendedClientCapabilities = extended_capabilities
        },
    })
end

return M
