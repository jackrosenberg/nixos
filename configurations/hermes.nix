{ pkgs, ... }:
{
  imports = [
    ../mods/bluetooth.nix
  ];
  environment.systemPackages = with pkgs; [
  ];
  # nixpkgs.config.allowBroken = true;
  programs = {
    steam.enable = true;
    nix-ld.enable = true;
  };
}
