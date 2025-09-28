{...}:
{
  # this file changes the defaults for sshing, adding fail2ban, endlessh (fuck the bots)
  # and hopefully makes stuff more secure in general
  services = {
    endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };
    fail2ban.enable = true;
    openssh = {
      enable = true;
      ports = [ 67 ]; # six sevennn
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
