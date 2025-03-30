{ config, pkgs, ... }:
{
  services.dashy = {
    enable = true;
    virtualHost.domain = "dashy";
    virtualHost.enableNginx = true;
  };
  networking.firewall.allowedTCPPorts = [ 8081 ];

  services.nginx.virtualHosts."dashy" = {
    listen = [
      {
        port = 8081; 
        addr="0.0.0.0"; 
        # ssl = false;
        # ssl = true;
      }
    ];
    # locations."/" = {
    #   proxyPass = "http://127.0.0.1:8081"; 
    # };
  };
}

