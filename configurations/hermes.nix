{ pkgs, ... }:
{
  imports = [
    ../mods/bluetooth.nix
    ../mods/foxfit.nix
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
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    accelerationDevices = null;
    # loc in zpool
    mediaLocation = "/mnt/external";
    environment.IMMICH_IGNORE_MOUNT_CHECK_ERRORS = "true";
  };
  # hardware.graphics.enable = true;
  # users.users.immich.extraGroups = [
  #   "video"
  #   "render"
  # ];

}
