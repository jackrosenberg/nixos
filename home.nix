{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    cowsay
    floorp
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
            # replace with your favorite file manager
            file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        };
    };
  };
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "vi-mode" ];
      };
      
      initContent = ''
        # Source powerlevel10k theme (after oh-my-zsh)
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        
        # Vi mode configuration
        export KEYTIMEOUT=1
        VI_MODE_SET_CURSOR=true

        # Load p10k configuration
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # Add keybinds
        bindkey -M viins 'jj' vi-cmd-mode
        bindkey -M viins '^R' history-incremental-search-backward
      '';
      
      shellAliases = {
        v = "nvim";
        ne = "nvim /etc/nixos/configuration.nix";
        ns = "sudo nixos-rebuild --cores 0 switch";
        hs = "home-manager switch";
        he = "nvim ~/nix-config/home.nix";
        cl = "clear";
      };
      
      history.size = 10000;
    };
    git = {
      enable = true;
      userName = "jack";
      userEmail = "github@jackr.eu";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };

    kitty.enable = true;
  };
}
