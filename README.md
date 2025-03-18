# Jack's Nixos

Ok, basic idea:
  Fast, reliable, declarative server that can provide as close to a guarantee to 100% uptime as I can get.
  Modular, understandable, and abstract.
  Redundancies for important data such as photos, backups, etc
    ZFS RAIDZ1/RAIDZ2
  Speed for data that I don't care about in the case of a catastrophic failure
    ZFS Stripe set?

  Current idea:
  zpool:
    vdev1: 3 SATA 1TB HDD
    vdev2: nvme ssd 1TB
    vdev3: 3 SATA 3TB HDD
  

  
