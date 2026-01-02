{ pkgs, config, ... }:
let
  port = 8081;
in
{
  age.secrets.todo.rekeyedFile = ../secrets/todo.age;
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "nextcloud";
    config = {
      adminpassFile = config.age.secrets.todo.path;
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
