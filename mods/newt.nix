{ config, pkgs, ... }:
let site = "excitable-platypus";
in
{
  # agenix
  age.secrets.newtConf.rekeyFile = ../secrets/newtConf.age;
  # imports = [ "/home/jack/dev/nixpkgs/nixos/modules/services/networking/newt.nix" ];
  services.newt = {
    enable = true;
    settings = {
      endpoint = "https://pangolin.spectrumtijger.nl";
    };
    # this could be a map
    blueprint = {
      proxy-resources = {
        jellyfin = {
          name = "Jellyfin";
          protocol = "http";
          full-domain = "jfn.spectrumtijger.nl";
          host-header = "spectrumtijger.nl";
          tls-server-name = "spectrumtijger.nl";
          targets = [
            {
              inherit site;
              hostname = "localhost";
              method = "http";
              port = 8096;
            }
          ];
          auth.sso-enabled = true;
        };
        immich = {
          name = "Immich";
          protocol = "http";
          full-domain = "photos.spectrumtijger.nl";
          host-header = "spectrumtijger.nl";
          tls-server-name = "spectrumtijger.nl";
          targets = [
            {
              inherit site;
              hostname = "localhost";
              method = "http";
              port = 2283;
            }
          ];
          auth.sso-enabled = true;
        };
      };
    };
    environmentFile = config.age.secrets.newtConf.path;
  };
}
