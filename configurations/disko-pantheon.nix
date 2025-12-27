{ lib, ... }:
# this is the extra config for pantheon's disks
let
  ## input: name
  ## output: encrypted zpool containing a dataset root 
  genZPool = name: {
    type = "zpool";
    rootFsOptions = {
      mountpoint = "none";
      compression = "zstd";
      "com.sun:auto-snapshot" = "false";
    };
    options.ashift = "12";
    # datasets config
    datasets = {
      root = {
        type = "zfs_fs";
        options = {
          encryption = "aes-256-gcm";
          mountpoint = "legacy";
          keyformat = "passphrase";
          keylocation = "prompt";
          "com.sun:auto-snapshot" = "false";
          atime = "off";
        };
      };
    };
  };
  ## takes a device name, "/dev/by-id"
  ## generates a vdev for the device, that's part 
  ## of the root "zroot" pool
  genVDev = deviceId: {                                                      
    "raidz1_${deviceId}" = {
      device = "/dev/disk/by-id/${deviceId}";
      type = "disk";
      content = {
        type = "gpt";
        partitions.zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "zaux";
          };
        };
      };
    };
  };
in
{
  disko.devices = {
    disk = lib.recursiveUpdate { # stupid fucking '//'
      bigboy = {
        device = "/dev/disk/by-id/ata-ST12000NM0127_ZJV5FQF4";
        type = "disk";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "ztert";
            };
          };
        };
      };
    }
      # generates a set of sets {raidz1_sdb = {...}; raidz1_sdc ... };
    (lib.mergeAttrsList (
      map genVDev [
        "ata-ST4000VN006-3CW104_WW65RSXB"
        "ata-SAMSUNG_HD204UI_S2H7J1CB220832"
        "ata-SAMSUNG_HD204UI_S2H7J9EB304927"
      ]
    ));
    zpool = {
      zaux = lib.recursiveUpdate (genZPool "aux") {
        datasets."root/photos" = {
          type = "zfs_fs";
          mountpoint = "/mnt/photos";
        };
      };
      ztert = lib.recursiveUpdate (genZPool "tert") {
        datasets."root/media" = {
          type = "zfs_fs";
          mountpoint = "/mnt/media";
        };
      };
    };
  };
  # override default id
  networking.hostId = lib.mkForce "ad62be05"; # head -c4 /dev/urandom | od -A none -t x4
}
