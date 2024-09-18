{ pkgs, stdenv, ... }:
let
  ver = "v0.11.0";
in
{
  harper-ls = stdenv.mkDerivation {
    name = "harper-ls";
    src = pkgs.fetchurl {
      url = "https://github.com/elijah-potter/harper/releases/download/${ver}/harper-ls-aarch64-apple-darwin.tar.gz";
      sha256 = "sha256-+4OEta3oplXU13nh9m7IxSE+sGXpXa02DpeyjC0TzsA=";
    };
    # Work around the "unpacker appears to have produced no directories"
    # case that happens when the archive doesn't have a subdirectory.
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/ent/default.nix
    sourceRoot = ".";
    installPhase = ''
        # cp $src $out
      mkdir -p $out/bin
      cp harper-ls $out/bin
    '';
  };
  # just in case is needed to compile from source, however rust compilation is slow, and fetching
  # the ready binary is much faster
  harper-ls-source = pkgs.rustPlatform.buildRustPackage {
    pname = "harper-ls";
    version = ver;
    src = pkgs.fetchFromGitHub {
      owner = "elijah-potter";
      repo = "harper";
      rev = ver;
      hash = "sha256-83Fg1oywYuvyc5aFeujH/g8Czi8r0wBUr1Bj6vwxNec";
    };
    cargoHash = "sha256-vZKlU7UcOUfsfrSzR6NeS/k04dAtIA/1I5PoGeIVRhI=";
    # buildPhase = ''
    #   mkdir -p $out
    # '';
    # installPhase = ''
    #   cp -r target/ $out
    # '';
  };
}
