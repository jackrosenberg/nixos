{ pkgs, modulesPath, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
    ../mods/ssh.nix
    ../mods/secrets.nix
    ../mods/shell.nix
    ../mods/home.nix
    ../mods/jelly.nix
    ../mods/pangolin.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      trusted-users = [
        "root"
        "jack"
      ]; # enable cachix
    };
    # garbage collection
    gc.automatic = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jack = {
    isNormalUser = true;
    description = "jack";
    extraGroups = [
      "networkmanager"
      "wheel"
      "nix-users"
    ];
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    dysk
    xauth
    wireguard-tools
    sqlite
    jq
    shh
    tree
    toybox
    # traefik-log-dashboard
  ];
  system.stateVersion = "25.11";
}
