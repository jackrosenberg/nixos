{ pkgs, lib, ... }:

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
        # shits FUCKED up bigtime
        # it's jumping around and stuff and making ghost edits
        # autocmds = [
        #   {
        #     desc = "Save folds when exit";
        #     event = [ "BufWinLeave" ];
        #     pattern = [ "*" ];
        #     callback = lib.generators.mkLuaInline ''
        #       function()
        #         if vim.bo.buftype == "" and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
        #           vim.cmd("mkview")
        #         end
        #       end
        #     '';
        #   }
        #   {
        #     desc = "Load folds when enter";
        #     event = [ "BufWinEnter" ];
        #     pattern = [ "*" ];
        #     callback = lib.generators.mkLuaInline ''
        #       function()
        #         if vim.bo.buftype == "" and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
        #           vim.cmd("loadview")
        #         end
        #       end
        #     '';
        #     # command = "loadview"; #silent!
        #   }
        # ];
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
          NormalFloat = {
            bg = "#555555";
          };
          FloatBorder = {
            fg = "#00FFFF";
          };
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
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
        };
        lazy.plugins = {
          "neo-tree.nvim" = {
            package = pkgs.vimPlugins.neo-tree-nvim;
            event = [
              {
                event = "User";
                pattern = "LazyFile";
              }
            ];
          };
        };
      };
    };
  };
}
