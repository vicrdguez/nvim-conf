# To have the full feature set for java dev, we need to get vscode java debug and test extensions
{ pkgs, lib, stdenv, ... }:
{
  java_debug = stdenv.mkDerivation {
    name = "java-debug-bundle";
    src = pkgs.vscode-extensions.vscjava.vscode-java-debug;
    buildPhase = "
    mkdir -p $out
    ";
    installPhase = ''
      cp share/vscode/extensions/vscjava.vscode-java-debug/server/* $out
    '';
  };
  java_test = stdenv.mkDerivation {
    name = "java-test-bundle";
    src = pkgs.vscode-extensions.vscjava.vscode-java-test;
    buildPhase = "
    mkdir -p $out
    ";
    installPhase = ''
      cp share/vscode/extensions/vscjava.vscode-java-test/server/* $out
    '';
  };
  eclipse-java-google-style = stdenv.mkDerivation {
    name = "eclipse-java-google-style";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
      sha256 = "sha256-51Uku2fj/8iNXGgO11JU4HLj28y7kcSgxwjc+r8r35E=";
    };
    dontUnpack = true;
    buildPhase = ''
      mkdir -p $out
    '';
    installPhase = ''
      cp ./* $out
    '';
  };
}
