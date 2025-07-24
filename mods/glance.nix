{ config, pkgs, ... }: {
  services.glance = {
    enable = true;
    openFirewall = true;
  };
}
