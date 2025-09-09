{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./mods/nvf.nix
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel
  };

  # TODO FIXME
  networking.hostName = "hermes"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

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
  };

  services = {
    # Enable the GNOME Desktop Environment.
    xserver = { 
      # Enable the X11 windowing system.
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Configure keymap in X11 
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # defaultUserShell = pkgs.zsh; # TODO homemanager
    users.jack = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "jack";
      extraGroups = [ "networkmanager" "wheel" "nix-users" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = { 
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      # enable cachix
      trusted-users = [ "root" "jack" ];
    };
    # garbage collection
    gc = {
      automatic = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    floorp
    jujutsu
    git
    unityhub
    file
    kitty
    ripgrep
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
