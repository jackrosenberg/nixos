# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
#  disko.devices.disk.main.device = "/dev/sda";
# }
{ pkgs, config, ...}:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # boot = { # WHAT DOES THIS DO???
            #   size = "1M";
            #   type = "EF02"; # for grub MBR
            # };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
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
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank"; # create a blank snapshot on creation

        # datasets config
        datasets = {
          # for all the stuff i want to save
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              "com.sun:auto-snapshot" = "true";
              encryption = "aes-256-gcm";
              mountpoint = "legacy";
            };
          };
          # for /nix/{store,var} Needs to persist as well
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
            options = {
              encryption = "aes-256-gcm";
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook = "zfs snapshot zroot/nix@empty";
          };
          # Where everything else lives, and is wiped on reboot by restoring a blank zfs snapshot.
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              encryption = "aes-256-gcm";
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook = ''
                zfs snapshot zroot/root@empty
            '';
          };
        };
      };
    };
  };
  # zfs zpool config
  # extra zfs config to make it work
   networking.hostId = "01330c81"; #head -c4 /dev/urandom | od -A none -t x4
   environment.systemPackages = [pkgs.zfs-prune-snapshots];
   boot = {
     # Newest kernels might not be supported by ZFS
     kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
     kernelParams = [
       "nohibernate"
       "zfs.zfs_arc_max=17179869184"
     ];
     supportedFilesystems = [ "vfat" "zfs" ];
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
