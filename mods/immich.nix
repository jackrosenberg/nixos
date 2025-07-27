{ ... }:
{
  services.immich = {
    enable = true;
    openFirewall = true;
    port = 2283;
    host = "0.0.0.0";
    accelerationDevices = null;
    # loc in zpool
    mediaLocation = "/mnt/nixpool/immich";
    environment.THUMB_LOCATION = "/var/lib/immich/thumbs";
  };
  hardware.graphics.enable = true;
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
