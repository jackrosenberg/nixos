{
  pkgs,
  lib,
  config,
  ...
}:
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
    nvtopPackages.amd
  ];

  users = {
    groups.media.members = [ "jellyfin" ];
    users.jellyfin.extraGroups = [
    "video"
    "render"
  ];
  };
  services = {
    jellyfin = common // {
      group = "media";
    };
    jellyseerr = lib.mkIf (config.networking.hostName == "pantheon") common;
  };
}
