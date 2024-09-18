# https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
# A plugin can either be a package or an attrset, such as
# { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
#   config = <config>; # String; a config that will be loaded with the plugin
#   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
#   # or as an 'opt' plugin, that can be loaded with `:packadd!`
#   optional = <true|false>; # Default: false
#   ...
# }
# 
# bleeding-edge plugins from flake inputs e.g.
# (mkNvimPlugin inputs.wf-nvim "wf.nvim") 
{ pkgs, inputs }:
let
  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  mkCustomPackage = file: pkgs.callPackage file { };
in
rec {
  cmp = with pkgs.vimPlugins; [
    nvim-cmp
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp-cmdline
    cmp-cmdline-history
    cmp_luasnip
  ];

  lsp = with pkgs.vimPlugins; [
    lspkind-nvim
    nvim-lspconfig
    fidget-nvim
  ];

  search = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-ui-select-nvim
    fzf-lua
  ];

  themes = with pkgs.vimPlugins; [
    kanagawa-nvim
    rose-pine
    catppuccin-nvim
  ];

  misc = with pkgs.vimPlugins; [
    # using all grammars for now, maybe later I'll chose just the specific ones I use
    # https://discourse.nixos.org/t/psa-if-you-are-on-unstable-try-out-nvim-treesitter-withallgrammars/23321/5
    nvim-treesitter.withAllGrammars
    luasnip
    gitsigns-nvim
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    oil-nvim
    mini-nvim
    conform-nvim
    nvim-jdtls
    heirline-nvim
  ];

  language_servers = with pkgs; [
    lua-language-server
    # nix LSP that uses nix c++ core code
    nixd
    # Java ls by eclipse
    jdt-language-server
    # yamlls
    yaml-language-server
    gopls
    rust-analyzer
    (mkCustomPackage ./harper.nix).harper-ls
  ];

  formatters = with pkgs;[
    stylua
    yamlfmt
    rustfmt
  ];


  all =
    cmp ++
    lsp ++
    search ++
    themes ++
    misc;

  allNoSearch =
    cmp ++
    lsp ++
    themes ++
    misc;

  extraPackages =
    language_servers ++
    formatters;
}
