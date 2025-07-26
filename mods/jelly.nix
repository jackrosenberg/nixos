{ pkgs, ... }:
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

  services = {
    jellyfin = common // {
      group = "media";
    };
    jellyseerr = common;
  };
}
