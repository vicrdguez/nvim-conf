# Vic's Neovim config

This is my personal neovim configuration using nix and flakes. The Nix part is based on the nice
[kickstart-nix.nvim] with minor changes to my liking.

If you use nix, you can test it **without installing**:

```bash
nix run github:vicrdguez/nvim-conf
```

You can add it to your nixos/nix-darwin config by using the included `overlay`:
```nix
{
    inputs = {
        # Your othe inputs [...]
        nvim-conf = {
          url = "github:vicrdguez/nvim-conf";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = 
        let
          # Add the neovim overlay that is exposed by this flake
          pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [ inputs.nvim-conf.overlays.default ];
          };
        in {
            # Your Nixos/nix-darwin modules. Adding the `pkgs.nvim-custom` to your package list
            # wil install this config
        }
}
```

Themes that interest me:
* https://github.com/cryptomilk/nightcity.nvim
* https://github.com/sho-87/kanagawa-paper.nvim?tab=readme-ov-file

[kickstart-nix.nvim]: https://github.com/mrcjkb/kickstart-nix.nvim/tree/main
