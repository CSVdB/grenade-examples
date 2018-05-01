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
            rev = "b18c2596c39e132ab85a05ea6f1d29b8c8375ab8";
            sha256 = "01qdvaswng4vb7la6ylm4xr04zyk9mgcql2wr8h5lj04q4lcn9ln";
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
