# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./mods/hyprland.nix
      ./mods/zfs.nix
      ./mods/backups.nix

      ./mods/nextcloud.nix
      ./mods/immich.nix
      ./mods/tailscale.nix
      ./mods/jelly.nix
      ./mods/vpncontainer.nix 
      ./mods/audiobookshelf.nix 
      ./mods/cloudflared.nix
      # ./mods/pangolin.nix

      ./mods/grafana.nix
      ./mods/prometheus.nix
      ./mods/graphite.nix
      ./mods/loki.nix
      ./mods/alloy.nix

      ./mods/nvf.nix

      ./dockerimgs/homarr/docker-compose.nix
      ./dockerimgs/actual/docker-compose.nix
      ./dockerimgs/dawarich/docker-compose.nix
  ];

  # services.fossorial = {
  #   enable = true;
  #   baseDomain = "spectrumtijger.nl";
  #   dashboardDomain = "pangolin.spectrumtijger.nl";
  #   letsEncryptEmail = "letsencrypt@jackr.eu";
  #   gerbilPort = 3004;
  #   openFirewall = true;
  # };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = { 
    hostName = "pantheon"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [ 80 443 ];
    # firewall.allowedUDPPorts = [ 51820 ];
    # firewall.enable = false;
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

  # this is sysctl if im not mistaken
  services = {
    # Configure keymap in X11
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm = {
        enable = true;
        #fuck u autosus
        autoSuspend = false;
      };
    };
  };
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers = { 
      enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # If no user is logged in, the machine will power down after 20 minutes.
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  systemd.targets = { 
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };


  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.jack = {
      isNormalUser = true;
      description = "jack";
      extraGroups = [ "
      networkmanager" "wheel" "nix-users" ];
      packages = with pkgs; [
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    extraInit = ''
      if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      fi
    '';
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      neovim
      inputs.agenix.packages."${system}".default
      jujutsu
      unzip
      rofi
      xclip
      tmux
      wget
      btop
      neofetch
      kitty
      zsh
      zsh-powerlevel10k
      docker-compose
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-compose # start group of containers for dev
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      smartmontools
      tree
      morph
      dysk
      wireguard-tools
      nvtopPackages.full
      rocmPackages.rocm-smi

      # fossorial-newt
      # fossorial-gerbil
      
    ];
  };
    programs = { 
      ssh.forwardX11 = true; # allow ssh x forwarding
      zsh.enable = true;
      neovim = {
        enable = true;
      };
  };
  system.stateVersion = "25.05"; # Did you read the comment?
}
