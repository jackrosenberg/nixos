{ config, pkgs, ... }:
{
  # agenix
  age = {
    secrets.lasuite.file = ../secrets/lasuite.age;
    secrets.garageRpcSecret.file = ../secrets/garageRpcSecret.age;
    secrets.garageAdminToken.file = ../secrets/garageAdminToken.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };
  services = {
    # lasuite-docs = {
    #   enable = true;
    #   domain = "jackr.eu";
    #   environmentFile = config.age.secrets.lasuite.path;
    # };
    garage = {
      enable = true;
      # stupid that this is not the default
      package = pkgs.garage;
      settings = {
        # no duplication
        replication_factor = 1;

        rpc_bind_addr = "[::]:3901";
        rpc_secret_file = config.age.secrets.garageRpcSecret.path;

        s3_api = {
          api_bind_addr = "[::]:3900";
          s3_region = "garage";
          root_domain = "jackr.eu";
        };

        admin = {
          api_bind_addr = "[::]:3903";
          admin_token_file = config.age.secrets.garageAdminToken.path;
        };
      };
    };
  };
}
