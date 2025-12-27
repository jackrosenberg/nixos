{ lib, ... }:
# this is the extra config for pantheon's disks
let
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
      # the root of the auxiliary pool, encrypted
      ${name} = {
        type = "zfs_fs";
        mountpoint = "/mnt";
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
  genVDev = device: {
    "raidz1_${device}" = {
      device = "${device}";
      type = "zfs_fs";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zaux";
            };
          };
        };
      };
    };
  };
in
{
  disko.devices = {
    disk = {
      bigboy = {
        device = "/dev/sda";
        type = "zfs_fs";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "ztert";
              };
            };
          };
        };
      };
    }
    // lib.mergeAttrsList (
      map genVDev [
        "/dev/sdb"
        "/dev/sdc"
        "/dev/sdd"
      ]
    );
    zpool = {
      zaux = (genZPool "aux") // {
        datasets."aux/media" = {
          type = "zfs_fs";
          mountpoint = "/mnt/media";
          options = {
            "com.sun:auto-snapshot" = "true";
            # mountpoint = "/mnt/media"; //check if needed
            atime = "off";
          };
        };
      };
      ztert = (genZPool "tert") // {
        datasets."tert/media" = {
          "aux/photos" = {
            type = "zfs_fs";
            mountpoint = "/mnt/photos";
            options = {
              "com.sun:auto-snapshot" = "true";
              # mountpoint = "/mnt/photos"; //check if needed
              atime = "off";
            };
          };
        };
      };
    };
  };
  # zfs zpool config
  # extra zfs config to make it work
  networking.hostId = "3530dc36"; # head -c4 /dev/urandom | od -A none -t x4
  boot = {
    # Newest kernels might not be supported by ZFS
    kernelParams = [
      "nohibernate"
      "zfs.zfs_arc_max=2147483648" # TODO READ UP ON OPTIMUM
    ];
    supportedFilesystems = [
      "vfat"
      "zfs"
    ];
    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
      requestEncryptionCredentials = true;
    };
  };
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
}
