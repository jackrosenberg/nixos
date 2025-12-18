{ config, ... }:
{
  # this file changes the defaults for sshing, endlessh (fuck the bots)
  # and hopefully makes stuff more secure in general
  services = {
    endlessh = {
      enable = config.networking.hostName == "kharon";
      port = 22;
      openFirewall = true;
    };
    # fail2ban.enable = true; # doesnt play nice with newt
    openssh = {
      enable = true;
      ports = [ 67 ]; # six sevennn
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
  # todo, make declarative file
  # users.users."jack".openssh.authorizedKeys.keyFiles = [
  #   /home/jack/.ssh/id_ed25519.pub
  # ];

  # for client
  # todo make this a beautiful map
  programs.ssh = {
    extraConfig = ''
      Host kharon
        Hostname 24.144.76.230
        Port 67
        User root
        IdentityFile ~/.ssh/id_ed25519_do
      # Host pantheon
      #   Hostname 
      #   Port 67
      #   User root
      #   IdentityFile ~/.ssh/id_ed25519
    '';

  };
}
