{ config, ... }:
{
  services.kubo = {
    enable = true;
  };
  # add user to group so we're allowed to access the daemon
  users.users.jack.extraGroups = [ config.services.kubo.group ];
}
