{
  pkgs,
  config,
  lib,
  ...
}:
{
  # https://francis.begyn.be/blog/nixos-restic-backups

  # this is the game plan: generate the file and store it encrypted with age
  # so i can use this on other builds as well. every time it is used, decrypt
  # it and run 'rclone config update PDrive' since the api token credentials
  # will be outdated. This needs to be done without a vpn becuz Proton is stupid.
  # After this, the rest goes through a vpn like usual

  # init repo with:
  # restic -v -r rclone:PDrive:/backups init

  ## RESTORE WITH
  # restic -r rclone:PDrive:backups restore latest --target /tmp/fotos
  ## note, PDrive, pw, username must be specified in the rclone conf
  ## TODO, symlink the conf at runtime for all machines
  ## conf is currently stored in /etc/nixos/secrets/rcloneConf.age

  environment.systemPackages = with pkgs; [
    rclone
    restic
  ];
  # agenix
  age = {
    secrets.resticPDrivePass.file = ../secrets/resticPDrivePass.age;
    secrets.rcloneConf.file = ../secrets/rcloneConf.age;
    identityPaths = [ "/etc/age/id_ed25519" ];
  };

  services.restic.backups = {
    PDrive = {
      backupPrepareCommand = ''
        # wipe statefull data
        ${lib.getExe pkgs.rclone} config update PDrive \
          client_uid= \
          client_access_token= \
          client_refresh_token= \
          client_salted_key_pass= 
        # add ip rule
        IP=$(${lib.getExe pkgs.dig} +short mail.proton.me | head -1)

        # Add route
        ${lib.getExe' pkgs.iproute2 "ip"} route add $IP via 192.168.2.1 dev enp5s0

        # run a fast command to re-gen credentials
        ${lib.getExe pkgs.rclone} lsd PDrive:

        # Del route
        ${lib.getExe' pkgs.iproute2 "ip"} route del $IP via 192.168.2.1 dev enp5s0
      '';
      rcloneConfigFile = config.age.secrets.rcloneConf.path;
      # needed for if backup failed
      rcloneOptions.protondrive-replace-existing-draft = true;
      progressFps = 1.666e-2; # print one update per min
      paths = [
        # what to backup
        "/mnt/nixpool/immich/library/"
      ];
      passwordFile = config.age.secrets.resticPDrivePass.path; # encryption
      initialize = true;
      repository = "rclone:PDrive:/backups"; # @ where to store it

      timerConfig = {
        # when to backup
        OnCalendar = "04:00";
      };
    };
  };
}
