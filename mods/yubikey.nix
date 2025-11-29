{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Yubikey
  # https://joinemm.dev/blog/yubikey-nixos-guide
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # allow yubikey login and sudo
  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      hyprlock.u2fAuth  = true;
    };
    u2f = {
      enable = true;
      authFile = pkgs.writeText "u2f-mappings" ''
        jack:Cr8jwIoVbx7D8eiDyjN0OT882w+a+DPbjlK8f8Jk+OtPGKwEJnWh2mVU0sz3A1Fi218txMqAGMJXXUKTMOh99A==,vxP9UtvrH5W/F7QlqbvHmtUdu1jnxac2cYz6dK3VKE1XRj/m313FkaONZu0thAfG+Ri+dRZahUu/RNXiyVA4hw==,es256,+presence
      '';
      settings = {
        # text prompt me hoe
        interactive = true;
        cue = true;
        origin = "pam://yubi";
      };
    };
  };
}
