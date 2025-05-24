{ pkgs, config, ...}:
{
    # https://francis.begyn.be/blog/nixos-restic-backups
    environment.systemPackages = with pkgs; [
     rclone
     restic
    ];
  # agenix
  age = {
    secrets.resticPDrivePass.file = ../secrets/resticPDrivePass.age;
    secrets.rcloneConf.file = ../secrets/rcloneConf.age;
    identityPaths = [
      "/etc/age/id_ed25519"
    ];
  };
  
  services.restic.backups = {
    PDrive = {
      initialize = true;
      rcloneConfigFile = config.age.secrets.rcloneConf.path;
      paths = [ # what to backup
        "/home/jack/Screenshots/"
      ];
      passwordFile = config.age.secrets.resticPDrivePass.path; # encryption
      repository = "rclone:PDrive:/backups"; # @ where to store it

      timerConfig = { # when to backup
        OnCalendar = "00:05";
      };
    };
  };
}
