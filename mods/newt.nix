{ config, pkgs, ... }:
{
  # agenix
  age = {
    secrets.newtConf.file = ../secrets/newtConf.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };
  services.newt = {
    enable = true;
    settings = {
      endpoint = "https://pangolin.spectrumtijger.nl";
    };
    # this could be a map
    # blueprint = {
    #   proxy-resources = {
    #     jellyfin = {
    #       name = "Jellyfin";
    #       protocol = "http";
    #       full-domain = "jfn.spectrumtijger.nl";
    #       targets = [
    #         {
    #           hostname = "localhost";
    #           method = "http";
    #           port = 8096;
    #         }
    #       ];
    #       auth.sso-enabled = true;
    #     };
    #     immich = {
    #       name = "Immich";
    #       protocol = "http";
    #       full-domain = "photos.spectrumtijger.nl";
    #       targets = [
    #         {
    #           hostname = "localhost";
    #           method = "http";
    #           port = 2283;
    #         }
    #       ];
    #       auth.sso-enabled = true;
    #     };
    #   };
    # };
    environmentFile = config.age.secrets.newtConf.path;
  };
}
