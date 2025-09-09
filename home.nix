{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # home.packages = with pkgs; [ ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
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
        bindkey -M viins 'jh' vi-cmd-mode
        bindkey -M viins '^R' history-incremental-search-backward
      '';
      
      shellAliases = {
        v = "nvim";
        ne = "nvim /etc/nixos/configuration.nix";
        ns = "sudo nixos-rebuild switch";
        hs = "home-manager switch";
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
        core.whitespace = "cr-at-eol";
        core.autocrlf = true;
      };
    };

    kitty.enable = true;
  };
}
