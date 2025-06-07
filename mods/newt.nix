{ config, ...}:
{
  # # agenix
  # age = {
  #   secrets.newtConf.file = ../secrets/newtConf.age;
  #   identityPaths = [
  #     "/etc/age/id_ed25519"
  #   ];
  # };
  services.newt = {
    enable = true;
    id = "m3t8hpho5ss6tfk";
    endpoint = "https://pang.spectrumtijger.nl";
    secretFile = /tmp/newt/conf;# config.age.secrets.newtConf.path;
  };
}
