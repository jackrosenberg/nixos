{ pkgs, ... }:

{
  imports = [
    ../mods/backups.nix
    ../mods/zfs.nix
    # ../mods/kanidm.nix
    ../mods/nextcloud.nix
    ../mods/immich.nix
    ../mods/jelly.nix
    ../mods/pirateship.nix
    ../mods/audiobookshelf.nix
    ../mods/cloudflared.nix
    ../mods/wastebin.nix
    ../mods/newt.nix
    ../mods/grafana.nix
    ../mods/prometheus.nix
    ../mods/loki.nix
    ../mods/alloy.nix
    ../mods/uptimekuma.nix
    ../mods/gitlabrunner.nix
    # ../dockerimgs/dawarich/docker-compose.nix # todo, replace with builtin imgs/service
    # /home/jack/dev/nix/nixpkgs/nixos/modules/services/networking/sozu.nix
  ];
  environment = {
    systemPackages = with pkgs; [
      citrix_workspace
    ];
  };
  # services.sozu.enable = true;
}
