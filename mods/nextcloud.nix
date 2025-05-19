{ config, pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud";
    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
    settings = {
      trusted_domains = [ "*.jackr.eu" "10.89.0.1" ];
    };
  };
 networking.firewall.allowedTCPPorts = [ 8080 ];

  services.nginx.virtualHosts."nextcloud" = {
    listen = [
      {
        port = 8080; 
        addr = "0.0.0.0"; 
      }
    ];
  };
}

