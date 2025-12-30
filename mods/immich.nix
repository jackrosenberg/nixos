{ ... }:
# how to restore backups:
#  make backups
#  activate immich as below, start service and run `rm -rf /var/lib/immich`
# then stop all the services (including postgres)
#
# `chown -R immich:immich /location/of/immich`
#
#  `systemctl start postgres.service` and `gunzip --stdout "./backups/immich-db-backup-<DATE>.11.sql.gz" | sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" | sudo -Hu immich bash -c 'psql --dbname=immich --username=immich'`
#
# environment.IMMICH_IGNORE_MOUNT_CHECK_ERRORS = "true";
#
# restart the services, regenerate thumbnails and klaar is kees

{
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    accelerationDevices = null;
    # loc in zpool
    mediaLocation = "/mnt/photos/";
    environment.THUMB_LOCATION = "/var/lib/immich/thumbs";
  };
  hardware.graphics.enable = true;
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
