{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        # disbles flake inputs error message
        lsp.servers.nixd.settings.nil.nix.autoArchive = true;
        theme = {
          enable = true;
          name = "dracula";
          style = "light";
        };
        options = {
          shiftwidth = 2;
          ignorecase = true;
          smartcase = true;
          foldmethod = "manual";
          viewoptions = "folds,cursor";
          foldenable = true;
          foldlevelstart = 0; # All folds closed when opening files
          foldlevel = 0; # Close all folds in current buffer
        };
        autocomplete.nvim-cmp = {
          enable = true;
          mappings = {
            confirm = "<CR>";
            next = "<Tab>";
            previous = "<S-Tab>";
            complete = "<C-Space>";
          };
        };
        highlight = {
          NormalFloat.bg = "#555555";
          FloatBorder.fg = "#00FFFF";
        };
        keymaps = [
          {
            key = "jk";
            mode = "i";
            action = "<esc>";
          }
          {
            key = "<CR>";
            mode = "n";
            action = "i<CR><Esc>";
          }
          {
            key = "<M-CR>";
            mode = "n";
            action = "m`o<Esc>``";
          }
          # error diagnostic open
          {
            key = "<M-S-k>";
            mode = "n";
            action = ":lua vim.diagnostic.open_float()<CR>";
          }
        ];

        # todo: make this a map
        languages = {
          nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          csharp = {
            enable = true;
            lsp = {
              enable = true;
              servers = [ "omnisharp" ];
            };
            treesitter.enable = true;
          };
          rust = {
            enable = true;
            lsp.enable = true;
            format.enable = true;
            treesitter.enable = true;
          };
          bash = {
            enable = true;
            lsp.enable = true;
            format.enable = true;
            treesitter.enable = true;
          };
          haskell = {
            enable = true;
            lsp.enable = true;
            # format.enable = true;
            treesitter.enable = true;
          };

        };
      };
    };
  };
}
