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
{ pkgs, inputs}:
let
  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
in
rec {
  all =
    cmp ++
    lsp ++
    search ++
    themes ++
    misc;

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
  ];

  search = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-ui-select-nvim
  ];

  themes = with pkgs.vimPlugins; [
    kanagawa-nvim
  ];

  misc = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    luasnip
    gitsigns-nvim
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    oil-nvim
    mini-nvim
  ];

  # language servers, etc.
  extraPackages = with pkgs; [
    lua-language-server
    nil # nix LSP
  ];
}
