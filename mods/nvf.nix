{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
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
              server = "omnisharp";
            };
            treesitter.enable = true;
          };
        };
        # lazy.plugins = {
        #   "omnisharp-extended-lsp.nvim" = {
        #     package = pkgs.vimPlugins.omnisharp-extended-lsp-nvim;
        #     event = [
        #       {
        #         event = "User";
        #         pattern = "LazyFile";
        #       }
        #     ];
        #   };
        # };
      };
    };
  };
}
