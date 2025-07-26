{ config, ... }:
{
  # agenix
  age = {
    secrets.newtConf.file = ../secrets/newtConf.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };
  services.newt = {
    enable = true;
    endpoint = "https://pang.spectrumtijger.nl";
    environmentFile = config.age.secrets.newtConf.path; # /tmp/newt/conf;#
  };
}
