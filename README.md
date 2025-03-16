# Jack's Nixos

Ok, basic idea:
  Fast, reliable, declarative server that can provide as close to a guarantee to 100% uptime as I can get.
  Modular, understandable, and abstract.
  Redundancies for important data such as photos, backups, etc
    ZFS RAIDZ1/RAIDZ2
  Speed for data that I don't care about in the case of a catastrophic failure
    ZFS Stripe set?

  Current idea:
  4 SATA + 1 M2 = 5 max vdevs???
    possible to split into multiple for faster speeds/more storage?
  use M2 as special vdev since its only 1TB??
  how does swap work/arc something?
  
