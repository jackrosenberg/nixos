{ pkgs, ... }:
{
  imports = [
    ../mods/bluetooth.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  environment.systemPackages = with pkgs; [
    unityhub
    vscode.fhs # barf
    dotnetCorePackages.sdk_9_0-bin
    meld
    citrix_workspace
    # haskellPackages.cabal-install
    # haskell.compiler.native-bignum.ghcHEAD
    # haskellPackages.base_4_21_0_0
  ];
  services.fprintd.enable = true;
  programs.steam.enable = true;
}
