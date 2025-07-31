{ config, pkgs, ... }:
{
  # agenix
  age = {
    secrets.newtConf.file = ../secrets/newtConf.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };
  services.newt = {
    enable = true;
    package = pkgs.newt-go.overrideAttrs (f: p: {
      version = "1.4.0";
      src.hash = "sha256-t1MqcrbYa5vojMOyn+iyExsUDQ1FQYlmZBFqyOkotyw=";
      vendorHash = "sha256-V8sq7XD/HJFKjhggrDWPdEEq3hjz0IHzpybQXA8Z/pg=";
    });
    endpoint = "https://pangolin.spectrumtijger.nl";
    environmentFile = config.age.secrets.newtConf.path; # /tmp/newt/conf;#
  };
}
