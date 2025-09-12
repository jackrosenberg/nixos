{ pkgs, ... }:
{
  home-manager.users.jack.programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "vi-mode" ];
      };
      
      # todo, redo
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
  # set default, shouldn't be needed, but i've been burnt b4
  environment.variables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };
  programs = {
    zsh.enable = true;
    neovim.enable = true;
  };
}
