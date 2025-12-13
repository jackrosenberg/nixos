{ pkgs, ... }:
{
  imports = [
    ../mods/bluetooth.nix
    ../mods/foxfit.nix
    ../mods/security.nix
  ];
  environment.systemPackages = with pkgs; [
    meld
    # citrix_workspace
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server
    ghc
    haskell.compiler.native-bignum.ghcHEAD
    # haskellPackages.base_4_21_0_0
    # foxfit
    # probe-rs
  ];
  # nixpkgs.config.allowBroken = true;
  programs = {
    steam.enable = true;
    nix-ld.enable = true;
  };
}
