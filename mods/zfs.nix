{ ... }:
{
  # # ZFS
  # boot.supportedFilesystems = [ "zfs" ];
  # boot.zfs.forceImportRoot = false;
  # networking.hostId = "ad62be05"; # head -c4 /dev/urandom | od -A none -t x4
  # services.zfs.autoScrub = {
  #   enable = true;
  #   interval = "*-*-1,15 02:30";
  # };
  # fileSystems."/mnt/nixpool" = {
  #   device = "nixpool";
  #   fsType = "zfs";
  # };
  # fileSystems."/mnt/nixpool/immich" = {
  #   device = "nixpool/immich";
  #   fsType = "zfs";
  # };
}
