{ pkgs, lib, config, ... }:
let
  common = {
    enable = true;
    openFirewall = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  users = {
    users.jellyfin = {};
    groups.media.members = [ "jellyfin" ];
  };
  services = {
    jellyfin = common // {
      group = "media";
    };
    jellyseerr = lib.mkIf (config.networking.hostName == "pantheon") common;
  };
}
