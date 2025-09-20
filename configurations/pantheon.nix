{ ... }:

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
      ../dockerimgs/dawarich/docker-compose.nix # todo, replace with builtin imgs/service
  ];
  environment = {
    extraInit = ''
      if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      fi
    '';
  };
}
