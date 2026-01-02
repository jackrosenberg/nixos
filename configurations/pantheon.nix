{ pkgs, ... }:

{
  imports = [
    # ../mods/backups.nix
    ../mods/zfs.nix
    # ../mods/kanidm.nix
    # ../mods/nextcloud.nix # stupid downgrading is not enabled
    # ../mods/wiki.nix
    ../mods/immich.nix
    ../mods/jelly.nix
    ../mods/pirateship.nix
    # ../mods/audiobookshelf.nix
    ../mods/cloudflared.nix
    ../mods/wastebin.nix
    ../mods/newt.nix
    ../mods/grafana.nix
    ../mods/prometheus.nix
    # ../mods/loki.nix
    ../mods/alloy.nix
    ../mods/uptimekuma.nix
    # ../mods/gitlabrunner.nix
    # ../mods/dawarich.nix ## reenable once dawarich hits unstable
  ];

  environment = {
    systemPackages = with pkgs; [
      # citrix_workspace
    ];
  };
}
