# Jack's Nixos
Ok, basic idea:
  Fast, reliable, (mostly) declarative server that can provide as close to a guarantee to 100% uptime as I can get.
  Modular, understandable, and abstract.
  Redundancies for important data such as photos, backups, etc
    ZFS RAIDZ1/RAIDZ2

## Config
### Storage
root: nvme ssd 1TB (fat32)
zpool: (zfs)
    /mnt/nixpool (vdev): raidz1 2x 2TB HDD (total: ~3.5 TB, protected for 1 disk failure)
other: (ext4)
    /mnt/media: 1x 4TB HDD 
 
## Services
### Immich
### Jellyfin + Jellyseerr
### Nextcloud
### Dashy

## Containers
### Vpn
#### OpenVpn
#### Prowlarr Sonarr + Radarr
#### Transmission


  

