{ config, ... }:
{
  age = {
    secrets.healthchecksEMailPw = {
      owner = "healthchecks";
      group = "healthchecks";
      file = ../secrets/healthchecksEMailPw.age;
    };
    secrets.healthchecksHTTPKey = {
      owner = "healthchecks";
      group = "healthchecks";
      file = ../secrets/healthchecksHTTPKey.age;
    };
    identityPaths = [
      "/etc/age/id_ed25519"
    ];
  };

  services.healthchecks = {
    enable = true;
    port = 8041;
    settings = {
      ADMINS = "admin@jackr.eu";
      # SECRET_KEY_FILE = config.age.secrets.healthchecksSecretKey.file ;
      DEFAULT_FROM_EMAIL = "healthchecks@jackr.eu"; # the "From:" address for outbound emails.
      EMAIL_HOST = "jackr.eu"; # the SMTP server.
      EMAIL_HOST_USER = "healthchecks@jackr.eu"; # the SMTP username.
      EMAIL_HOST_PASSWORD_FILE = config.age.secrets.healthchecksEMailPw.path; # the SMTP password.
      SECRET_KEY_FILE = config.age.secrets.healthchecksHTTPKey.path;# secures HTTP sessions, set to a random value.
      SITE_ROOT = "healthcheck.jackr.eu"; # The base public URL of your Healthchecks instance. Example: SITE_ROOT=https://hc.example.org.
    };
  };
}
