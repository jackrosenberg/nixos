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
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server
    ghc
    haskell.compiler.native-bignum.ghcHEAD
    # haskellPackages.base_4_21_0_0
  ];
  services.fprintd.enable = true;
  programs.steam.enable = true;
  programs.nix-ld = {
    enable = true;
  };
  # ## USB protocol foxfit
  # users = { 
  #   users.jack.extraGroups = ["plugdev"];
  #   groups.plugdev = {};
  # };
  #
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="usb", MODE="0660", GROUP="plugdev"
  # '';
}
