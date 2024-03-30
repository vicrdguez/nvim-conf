require('conform').setup {
    formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixpkgs_fmt' },
    },
}
