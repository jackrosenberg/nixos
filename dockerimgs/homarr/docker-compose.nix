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
  virtualisation.oci-containers.containers."homarr" = {
    image = "ghcr.io/homarr-labs/homarr:latest";
    environment = {
      "SECRET_ENCRYPTION_KEY" = "5c677f33122dfc3dfb1d79bd799e086a9a420edaf58a3bd3f97a8c1fc6ac6d80";
    };
    volumes = [
      "/etc/nixos/dockerimgs/homarr/appdata:/appdata:rw"
      "/var/run/podman/podman.sock:/var/run/podman/podman.sock:rw"
    ];
    ports = [
      "7575:7575/tcp"
    ];
    extraOptions = [
      "--network-alias=homarr"
      "--network=homarr_default"
    ];
  };
}
