{ config, ... }: {
  age = {
    secrets.healthchecksSettings = {
      owner = "healthchecks";
      group = "healthchecks";
      file = ../secrets/healthchecksSettings.age;
    };
    identityPaths = [ "/etc/age/id_ed25519" ];
  };

  services.healthchecks = {
    enable = true;
    port = 8041;
    settingsFile = config.age.secrets.healthchecksSettings.path;
    settings = {
      ADMINS = "admin@jackr.eu";
      DEFAULT_FROM_EMAIL =
        "healthchecks@jackr.eu"; # the "From:" address for outbound emails.
      EMAIL_HOST = "jackr.eu"; # the SMTP server.
      EMAIL_HOST_USER = "healthchecks@jackr.eu"; # the SMTP username.
      SITE_ROOT =
        "http://hc.jackr.eu"; # The base public URL of your Healthchecks instance. Example: SITE_ROOT=https://hc.example.org.
    };
  };
}
