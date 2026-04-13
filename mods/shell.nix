{ pkgs, config, ... }:
let
  keytext = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJGljEPDxM2BHivJPo+F48MSvWL4W1ah7SYU4cOAML0UAAAABHNzaDo=";
  key = builtins.toFile "ssh_pub_key" keytext;
  name = "Jack Rosenberg";
  email = "github@jackr.eu";
in
{
  home-manager.users.jack = {
    programs = {
      jujutsu = {
        enable = true;
        settings = {
          # snapshot.max-new-file-size = "5MiB";
          ui.editor = "nvim";
          operation = {
            hostname = config.networking.hostName;
            username = name;
          };
          user = {
            inherit
              name
              email
              ;
          };
          signing = {
            inherit key;
            backend = "ssh";
            sign-all = true;
            behavior = "drop";
          };
          git.sign-on-push = true;
        };
      };
      git = {
        enable = true;
        settings = {
          user = {
            inherit
              name
              email
              ;
            # create a dummy file in the store containing my pubkey
            signingkey = key;
          };
          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = builtins.toFile "git_allowed_signers" ''
              "${email} ${keytext}"
            '';
          };
          commit.gpgsign = true;
          init.defaultBranch = "main";
          safe.directory = "/etc/nixos";
          core = {
            whitespace = "cr-at-eol";
            autocrlf = "input";
          };
        };
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "vi-mode"
            "direnv"
          ];
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
          bindkey -M viins '^R' history-incremental-search-backward
          # Use direnv
          eval "$(direnv hook zsh)"
        '';

        shellAliases = {
          v = "nvim";
          ne = "nvim /etc/nixos/configurations/${config.networking.hostName}.nix";
          cl = "clear";
          jarvis = "jj";
          sys = "systemctl";
          # "jj gf" = "jj git fetch --all-remotes";
        };

        history.size = 10000;
      };
      kitty.enable = true;
    };
  };

  # set default, shouldn't be needed, but i've been burnt b4
  environment = {
    systemPackages = with pkgs; [
      zsh
      zsh-powerlevel10k
    ];
    variables = {
      TERMINAL = "kitty";
      TERM = "kitty";
      EDITOR = "nvim";
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = "true";
      # SHELL = "zsh"; # BREAKS EVERYTHING
    };
  };
  programs = {
    zsh.enable = true;
    neovim.enable = true;
  };
  users.users.jack.shell = pkgs.zsh;
}
