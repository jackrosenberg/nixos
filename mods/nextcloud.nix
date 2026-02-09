{ pkgs, config, ... }:
let
  port = 8081;
in
{
  age.secrets.nextcloud.rekeyFile = ../secrets/nextcloud.age;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "nextcloud";
    config = {
      adminpassFile = config.age.secrets.nextcloud.path;
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
