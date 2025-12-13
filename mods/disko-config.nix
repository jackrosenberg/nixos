# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
#  disko.devices.disk.main.device = "/dev/sda";
# }
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "nofail"
                  "umask=0077"
                ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        options.ashift = "12";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank"; # create a blank snapshot on creation

        # datasets config
        datasets = {
          # Where everything else lives, and is wiped on reboot by restoring a blank zfs snapshot.
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              encryption = "aes-256-gcm";
              mountpoint = "legacy";
              keyformat = "passphrase";
              keylocation = "prompt";
              "com.sun:auto-snapshot" = "false";
              atime = "off";
            };
            postCreateHook = "zfs snapshot zroot/root@empty";
          };
          # for all the stuff i want to save
          "root/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "/persist";
              atime = "off";
            };
          };
          # for /nix/{store,var} Needs to persist as well
          "root/nix" = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
            options = {
              "com.sun:auto-snapshot" = "false";
              atime = "off";
            };
            # causes break
            # postCreateHook = "zfs snapshot zroot/nix@empty";
          };
        };
      };
    };
  };
  # zfs zpool config
  # extra zfs config to make it work
  networking.hostId = "01330c81"; # head -c4 /dev/urandom | od -A none -t x4
  boot = {
    # Newest kernels might not be supported by ZFS
    kernelParams = [
      "nohibernate"
      "zfs.zfs_arc_max=2147483648"
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
