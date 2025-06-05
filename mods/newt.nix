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
    configFile = /tmp/newt/conf.json;# config.age.secrets.newtConf.path;
  };
}
