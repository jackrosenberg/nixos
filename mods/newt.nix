{ config, pkgs, ... }:
{
  # agenix
  age = {
    secrets.newtConf.file = ../secrets/newtConf.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };
  imports = [ "/home/jack/dev/nix/nixpkgs/nixos/modules/services/networking/not-newt.nix" ];
  services.not-newt = {
    enable = true;
    settings = {
      endpoint = "https://pangolin.spectrumtijger.nl";
    };
    environmentFile = config.age.secrets.newtConf.path;
  };
}
