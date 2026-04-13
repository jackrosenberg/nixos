{
  self,
  config,
  lib,
  ...
}:
{
  # use an sshkey that requires yubikey and PasswordAuthentication
  # (agenix) encrypt the public key and part of the private key, and put them into the store
  # point the identityfile to /run/agenix.d/... and voila
  ## even if the yubikey is stolen/lost, you would still need
  ## a password to impersonate me
  age.secrets = {
    ssh_id_ed25519_sk = {
      rekeyFile = ../secrets/ssh_id_ed25519_sk.age;
      owner = "jack";
    };
  };
  # changes the defaults for sshing, endlessh (fuck the bots)
  # and hopefully makes stuff more secure in general
  services = {
    endlessh = {
      enable = config.networking.hostName == "kharon";
      port = 22;
      openFirewall = true;
    };
    # fail2ban.enable = true; # doesnt play nice with newt
    openssh = {
      enable = true;
      ports = [ 67 ]; # six sevennn
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
  # todo, make declarative file
  # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDBf83p/RKzM7wlWuC0E7mG3LYGRWqNjO2I0wGVPdbr"
  users.users."root".openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJGljEPDxM2BHivJPo+F48MSvWL4W1ah7SYU4cOAML0UAAAABHNzaDo="
  ];

  # for client
  programs.ssh =
    # for all the hosts named in my flake
    # use port 67, and my sshkey
    let
      genConfig = hostName: ''
        Host ${hostName}
          Port 67
          User root
      '';
    in
    {
      extraConfig =
        (lib.concatMapStringsSep "\n" genConfig (builtins.attrNames self.nixosConfigurations))
        + ''

          Host kharon
            Hostname 24.144.79.217
          Host * 
            IdentityFile ${config.age.secrets.ssh_id_ed25519_sk.path}

          AddKeysToAgent yes
        '';
      startAgent = true;
    };
}
