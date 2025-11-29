{...}:
{
  # firmwareupdate
  services.fwupd.enable = true;
  # hehe gimp suit ram
  # https://wiki.nixos.org/wiki/Swap`
  # zramSwap = { # thanks sigmasquadron
  #   algorithm = "zstd";
  #   enable = true;
  #   memoryMax = 8589934592;
  #   memoryPercent = 50;
  #   priority = 32;
  # };
  # also encrypt it with key in ram
  # this way becomes unreadable if ram is dead
}
