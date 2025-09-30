{ pkgs, inputs, ... }:

{
  imports = [
    ../mods/shell.nix
    ../mods/ssh.nix
    ../mods/hyprland.nix
    ../mods/home.nix # fuck you homemanager
    ../mods/tailscale.nix
    ../mods/nvf.nix
  ];
  # # REMOVE ME WHEN DONE
  nixpkgs.config.permittedInsecurePackages = [
    "libxml2-2.13.8"
    "libsoup-2.74.3"
  ];
  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  # make paths for the folders
  systemd.tmpfiles.settings."10-jack-nixos-folders" = {
    "/etc/nixos/secrets".d = {
      user = "jack";
      mode = "0700";
    };
    "/etc/nixos/mods".d = {
      user = "jack";
      mode = "0700";
    };
    "/etc/nixos/configurations".d = {
      user = "jack";
      mode = "0700";
    };
  };
  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  services = {
    displayManager.gdm = {
      enable = true;
      autoSuspend = false; # fuck u autosus
    };
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver.enable = true;
  };
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
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
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "jack";
    extraGroups = [
      "networkmanager"
      "wheel"
      "nix-users"
    ];
  };
  security = {
    rtkit.enable = true;
  };

  environment = {
    variables.NIX_BUILD_CORES = 0;
    systemPackages = with pkgs; [
      neovim
      inputs.agenix.packages."${system}".default
      jujutsu
      unzip
      zip
      rofi
      xclip
      tmux
      wget
      toybox
      floorp-bin
      dust
      btop
      neofetch
      kitty
      lshw
      zsh
      zsh-powerlevel10k
      docker-compose
      dive # look into docker image layers
      smartmontools
      tree
      morph
      dysk
      ripgrep
      wastebin
      wireguard-tools
      # nvtopPackages.full # breaks often on update
      rocmPackages.rocm-smi
      via
      usbutils
      bat
      shh
      signal-desktop
      parted
      jq
      nautilus
      nixpkgs-review
      nixfmt-tree
      nixf-diagnose
      gh
      nodejs_20
      go
      sqlite
    ];
  };
  programs = {
    # sets some env vars like $EDITOR
    zsh.enable = true;
    neovim.enable = true;
  };
  system.stateVersion = "25.05"; # Did you read the comment?
}
