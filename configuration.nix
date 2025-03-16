
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./mods/nextcloud.nix
      ./mods/cloudflared.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = { 
    hostName = "nixos"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [ 80 443 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # nat.enable = true;
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
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };

    };
    # Enable CUPS to print documents.
    printing.enable = true;
    # bigboi
    tailscale = { 
      enable = true;
      useRoutingFeatures = "server";
    };

    immich = {
      enable = true;
      openFirewall = true;
      port = 2283;
      host = "0.0.0.0";
      # accelerationDevices = null;
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
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
    users.immich.extraGroups = [ "video" "render" ];
    users.jack = {
      isNormalUser = true;
      description = "jack";
      extraGroups = [ "networkmanager" "wheel" "nix-users" ];
      packages = with pkgs; [
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    extraInit = ''
      if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      fi
    '';
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      neovim
      wget
      btop
      geekbench
      git
      neofetch
      kitty
      zsh
      zsh-powerlevel10k
      vimPlugins.nvim-treesitter.withAllGrammars
      docker-compose
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-compose # start group of containers for dev
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
    programs = { 
      zsh.enable = true;
      neovim = {
        enable = true;
	# extraConfig = ":luafile ~/.config/nvim/init.lua";
        # plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
      };
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
