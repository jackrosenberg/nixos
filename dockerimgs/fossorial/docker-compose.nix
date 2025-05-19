# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."gerbil" = {
    image = "fosrl/gerbil:1.0.0";
    volumes = [
      "/etc/nixos/dockerimgs/fossorial/config:/var/config:rw"
    ];
    ports = [
      "51820:51820/udp"
      "443:443/tcp"
      "80:80/tcp"
    ];
    cmd = [ "--reachableAt=http://gerbil:3003" "--generateAndSaveKeyTo=/var/config/key" "--remoteConfig=http://pangolin:3001/api/v1/gerbil/get-config" "--reportBandwidthTo=http://pangolin:3001/api/v1/gerbil/receive-bandwidth" ];
    dependsOn = [
      "pangolin"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
    ];
  };
  virtualisation.oci-containers.containers."pangolin" = {
    image = "fosrl/pangolin:1.2.0";
    volumes = [
      "/etc/nixos/dockerimgs/fossorial/config:/app/config:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=[\"curl\", \"-f\", \"http://localhost:3001/api/v1/\"]"
      "--health-interval=3s"
      "--health-retries=15"
      "--health-timeout=3s"
    ];
  };
  virtualisation.oci-containers.containers."traefik" = {
    image = "traefik:v3.3.3";
    volumes = [
      "/etc/nixos/dockerimgs/fossorial/config/letsencrypt:/letsencrypt:rw"
      "/etc/nixos/dockerimgs/fossorial/config/traefik:/etc/traefik:ro"
    ];
    cmd = [ "--configFile=/etc/traefik/traefik_config.yml" ];
    dependsOn = [
      "gerbil"
      "pangolin"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gerbil"
    ];
  };
}
