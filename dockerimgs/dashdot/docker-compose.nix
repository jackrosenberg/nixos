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
  virtualisation.oci-containers.containers."dashdot-dash" = {
    image = "mauricenino/dashdot:latest";
    volumes = [
      "/etc/nixos/dockerimgs/dashdot/dashdot-data:/data:rw"
    ];
    ports = [
      "3001:3001/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=dash"
      # "--network=dashdot_default"
      "--privileged"
    ];
  };
}
