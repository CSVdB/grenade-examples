{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  haskellPackagesOrig = if compiler == "default"
                        then pkgs.haskellPackages
                        else pkgs.haskell.packages.${compiler};

  haskellPackages = haskellPackagesOrig.override {
    overrides = self: super: with pkgs.haskell.lib; {
      genvalidity-hspec        = pkgs.haskell.lib.dontCheck super.genvalidity-hspec;
      genvalidity-hspec-cereal = pkgs.haskell.lib.dontCheck super.genvalidity-hspec-cereal;
      genvalidity-hspec-aeson  = pkgs.haskell.lib.dontCheck super.genvalidity-hspec-aeson;

      grenade = let
          src = pkgs.fetchFromGitHub {
            owner = "Nickske666";
            repo = "grenade";
            rev = "7979817a6085ffa9f82c12a3ec8db2a88f263d7f";
            sha256 = "1amcwpqbd6qik243yfa1bnd6dd4wymiivqpgp5pbgbx4ji4knvp6";
          };
          drv = super.haskellSrc2nix {
            name = "grenade";
            src = src + "/grenade.cabal";
          };
          drv2 = super.callPackage drv {};
        in overrideCabal drv2 (_drv: {inherit src;});

      grenade-examples = overrideCabal
        (super.callPackage (super.haskellSrc2nix {
          name = "grenade-examples";
          src = ./grenade-examples.cabal;
        }) {})
        (_drv: {src = ./.;});
    };
  };

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant haskellPackages.grenade-examples;

in

  if pkgs.lib.inNixShell then drv.env else drv
