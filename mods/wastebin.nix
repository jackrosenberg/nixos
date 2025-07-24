{ ... }: {
  services.wastebin = {
    enable = true;
    # stupid setting has a default of 1KB, this is 10MB
    settings.WASTEBIN_MAX_BODY_SIZE = 10485760;
  };
}
