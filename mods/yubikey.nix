{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # allow yubikey login and sudo
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
