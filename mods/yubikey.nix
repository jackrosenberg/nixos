{ pkgs, ... }:
{
  # https://joinemm.dev/blog/yubikey-nixos-guide
  ## for pam login
  # https://wiki.nixos.org/wiki/Yubikey
  # run `pamu2fcfg`, copy into `authfile field`

  services = {
    udev.packages = with pkgs; [ yubikey-personalization ];
    pcscd.enable = true;
  };
  environment.systemPackages = with pkgs; [
    yubikey-manager
    age-plugin-yubikey
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # allow yubikey login and sudo
  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      hyprlock.u2fAuth = true;
      # for the CCID mode (smart card)
    };
    u2f = {
      enable = true;
      settings = {
        # key, and backup key
        # generated with
        # $ pamu2fcfg -o pam://yubi -n
        authfile = pkgs.writeText "u2f-mappings" ''
          jack:Cr8jwIoVbx7D8eiDyjN0OT882w+a+DPbjlK8f8Jk+OtPGKwEJnWh2mVU0sz3A1Fi218txMqAGMJXXUKTMOh99A==,vxP9UtvrH5W/F7QlqbvHmtUdu1jnxac2cYz6dK3VKE1XRj/m313FkaONZu0thAfG+Ri+dRZahUu/RNXiyVA4hw==,es256:mT584CLzWzTHQaF1zve5dbekPB5wOkYwUcAfZ7eAs5reWKWO1Qze476pmWruc7yz6w0nop2pfMDhUnzKAit9TQ==,fTh9WO2SZolkDItBEI9hf3LVlARhecg01tck/BhxAjV6/uG838Izk7qFP1GsDgI4VOcXq7DArtrem6MlFJNq0Q==,es256
        '';
        userpresence = 0;
        # prompt b4 checking if yubikey
        # cue = true;
        debug = true;
        # dont text prompt me hoe
        # interactive = true;
        origin = "pam://yubi";
      };
    };
  };
}
