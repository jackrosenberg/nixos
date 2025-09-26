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
  ];
  services.fprintd.enable = true;
}
