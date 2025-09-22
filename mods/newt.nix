{ config, pkgs, ... }:
{
  # agenix
  age = {
    secrets.newtConf.file = ../secrets/newtConf.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };
  imports = [ "/home/jack/dev/nix/nixpkgs/nixos/modules/services/networking/newt_TEST.nix" ];
  services.newt_TEST = {
    package = pkgs.buildGoModule rec {
      pname = "newt";
      version = "1.5.0";
      src = pkgs.fetchFromGitHub {
        owner = "fosrl";
        repo = "newt";
        tag = version;
        hash = "sha256-uIlBAqe93MqMSN0Nghlfa1cLbMlcg3iMCzIu0U16h5o=";
      };
      vendorHash = "sha256-FeDNv1mLTvXYUDOHzyPP7uA+fOt/j0VT7CM6IyoMuTQ=";
      postPatch = ''
        substituteInPlace main.go \
          --replace-fail "version_replaceme" "${version}"
      '';
      ldflags = [
        "-s"
        "-w"
      ];
    };

    enable = true;
    settings = {
      endpoint = "https://pangolin.spectrumtijger.nl";
    };
    # this could be a map
    proxy-resources = {
      proxy-resources = {
        jellyfin = {
          name = "Jellyfin";
          protocol = "http";
          full-domain = "jfn.spectrumtijger.nl";
          # host-header = "spectrumtijger.nl";
          tls-server-name = "spectrumtijger.nl";
          targets = [
            {
              site = "glass-black-capped-marmot";
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
          # host-header = "spectrumtijger.nl";
          tls-server-name = "spectrumtijger.nl";
          targets = [
            {
              site = "glass-black-capped-marmot";
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
