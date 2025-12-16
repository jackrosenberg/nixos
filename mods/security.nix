{ pkgs, lib, ... }:
{
  # firmwareupdate
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    flashrom
    sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  # zramSwap.enable = true; # Creates a zram block device and uses it as a swap device
  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
    priority = 32;
  };

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      autoGenerateKeys.enable = true;
      # https://nix-community.github.io/lanzaboote/how-to-guides/automatically-enroll-keys.html
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
