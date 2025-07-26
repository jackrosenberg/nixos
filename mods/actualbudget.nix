{ pkgs, ... }:
{
  imports = [ ./../pkgs/actualbudget.nix ];

  ####################
  # Actual Budget 💵 #
  ####################
  #./pkgs/actual.nix;
  services.actual.enable = true;
  services.actual.port = 5006;
  services.nginx.virtualHosts."actual.jackr.eu" = {
    serverName = "actual.jackr.eu";
    enableACME = true; # Use ACME certs
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:5006";
  };
}
