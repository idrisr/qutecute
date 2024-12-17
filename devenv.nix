{ pkgs, ... }:
let compiler = "ghc965";
in {
  packages = with pkgs.haskell.packages."${compiler}"; [
    fourmolu
    cabal-fmt
    ghcid
    implicit-hie
  ];

  languages.haskell.enable = true;
}
