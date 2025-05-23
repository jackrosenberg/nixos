# Jack's Nixos
Ok, basic idea:
  Fast, reliable, (mostly) declarative server that can provide as close to a guarantee to 100% uptime as I can get.
  Modular, understandable, and abstract.
  Redundancies for important data such as photos, backups, etc
    - ZFS RAIDZ1
    - Kopia + rclone + ProtonDrive

## Storage
- root: nvme ssd 1TB (ext4)
- zpool: (zfs)
    - /mnt/nixpool : raidz1 3x 2TB HDD (total: ~3.6 TB, protected for 1 disk failure)
- media storage: (ext4)
    - /mnt/media: 1x 4TB HDD
### Backups:
- Kopia + rclone + ProtonDrive
 
## Services
### Immich
### Jellyfin + Jellyseerr
### Nextcloud

## Containers
### Vpn
#### OpenVpn
#### Prowlarr Sonarr + Radarr
#### Transmission


  

