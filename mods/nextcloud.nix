{ config, pkgs, ... }:
{
environment.etc."nextcloud-admin-pass".text = "PWD";
services.nextcloud = {
  enable = true;
  hostName = "localhost";

  config = {
    adminpassFile = "/etc/nextcloud-admin-pass";
    dbtype = "sqlite";
  };
  settings = {
    trusted_domains = [ "nextcloud.jackr.eu" ];
    overwriteprotocol = "https";
  };
};

}

