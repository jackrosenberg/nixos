{ pkgs, ... }:
{
  imports = [
    ../mods/bluetooth.nix
    ../mods/foxfit.nix
  ];
  environment.systemPackages = with pkgs; [
  ];
  # nixpkgs.config.allowBroken = true;
  programs = {
    steam.enable = true;
    nix-ld.enable = true;
  };
}
