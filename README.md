# Server
Ok, basic idea:
  Fast, reliable, (mostly) declarative server that can provide as close to a guarantee to 100% uptime as I can get.
  Modular, understandable, and abstract.
  Redundancies for important data such as photos, backups, etc
    - ZFS RAIDZ1
    - Restic + rclone + ProtonDrive

## Storage
- root: nvme ssd 1TB (ext4)
- zpool: (zfs)
    - /mnt/nixpool : raidz1 3x 2TB HDD (total: ~3.6 TB, protected for 1 disk failure)
- media storage: (ext4)
    - /mnt/media: 1x 12TB HDD (refurbished)
### Backups:
- Restic + rclone + ProtonDrive

# Laptop
## disko + ZFS on root and on for ephemerial root partition 
1 partition for boot partition (unencrypted, vfat)
1 partition for rest (zfs)
  - 1 dataset /persist (encrypted)
  - 1 dataset /nix (unencrypted)

lanzaboote 

yubikey + TPM unlock?

sources/resources:
https://ryanseipp.com/posts/nixos-encrypted-root/
https://notthebe.ee/blog/nixos-ephemeral-zfs-root/
https://grahamc.com/blog/erase-your-darlings/
https://yomaq.github.io/posts/zfs-encryption-backups-and-convenience/
