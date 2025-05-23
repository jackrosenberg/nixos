{ pkgs, config, ...}:
{
    services.restic.backups = {
    remotebackup = {
      initialize = true;
      paths = [ # what to backup
        "/persistent"
      ];
      passwordFile = config.age.secrets.restic-hetzner-password.path; # encryption
      repository = "sftp://<boxname>-<subN>@<boxname>.your-storagebox.de/"; # @ where to store it
      
      extraOptions = [
        # how to connect
        "sftp.command='${pkgs.sshpass}/bin/sshpass -f ${config.age.secrets.restic-hetzner.path} -- ssh -4 u419690.your-storagebox.de -l u419690-sub1 -s sftp'"
      ];
      timerConfig = { # when to backup
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };
  };
}
