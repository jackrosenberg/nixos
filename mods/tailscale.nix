{ config, ... }:
{
  # run:
  # sudo tailscale login
  # sudo tailscale cert HOSTNAME.tail3f92ab.ts.net
  services.tailscale = {
    enable = true;
    useRoutingFeatures = if (config.networking.hostName == "pantheon") then "server" else "none";
  };
}
