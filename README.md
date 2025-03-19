# Jack's Nixos

Ok, basic idea:
  Fast, reliable, declarative server that can provide as close to a guarantee to 100% uptime as I can get.
  Modular, understandable, and abstract.
  Redundancies for important data such as photos, backups, etc
    ZFS RAIDZ1/RAIDZ2
  Speed for data that I don't care about in the case of a catastrophic failure
    ZFS Stripe set?

  Current idea:
  OS + swap: nvme ssd 1TB
  zpool:
    vdev1: raidz1 2x 1TB HDD + 1 2TB HDD (total: 2 TB, protected for 1 disk failure)
      plan to swap in the 4, and another <2TB HDD eventually/when a disk fails
    vdev3: stripe 1x 4TB HDD
        

  

  
