{ pkgs, ... }:
let
  port = 8081;
in
{
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "nextcloud";
    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
    settings = {
      trusted_domains = [
        "*.jackr.eu"
        "*.spectrumtijger.nl"
        "10.89.0.1"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ port ];

  services.nginx.virtualHosts."nextcloud" = {
    listen = [
      {
        inherit port;
        addr = "0.0.0.0";
      }
    ];
  };
}
