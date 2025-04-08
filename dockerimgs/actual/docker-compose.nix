# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces = let
    matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [ 53 ];
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."actual" = {
    image = "docker.io/actualbudget/actual-server:latest";
    volumes = [
      "/etc/nixos/dockerimgs/actual/actual-data:/data:rw"
    ];
    ports = [
      "5006:5006/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=node src/scripts/health-check.js"
      "--health-interval=1m0s"
      "--health-retries=3"
      "--health-start-period=20s"
      "--health-timeout=10s"
      "--network-alias=actual_server"
      # "--network=actual_default"
    ];
  };
}
