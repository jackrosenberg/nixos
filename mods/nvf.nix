{ config, lib, pkgs, ... }:

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
          shiftwidth = 4;
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
          NormalFloat = { bg = "#555555"; };
          FloatBorder = { fg = "#00FFFF"; };
        };
        keymaps = [
          {
            key = "jj";
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
        
        languages = {
          nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
        };
        lazy.plugins = {
          "neo-tree.nvim" = {
            package  = pkgs.vimPlugins.neo-tree-nvim;
             event = [{event = "User"; pattern = "LazyFile";}];
          };
        };
      };
    };
  };

}
#
# --TODO: add lang agnostic comment command for cmd /  
# -- language agnostic fun command on <F2>
#
# vim.opt.signcolumn = 'yes'
# vim.opt.ignorecase = true

# Heads
# heads
# vim.opt.smartcase = true
# vim.opt.smarttab = true
# vim.opt.expandtab = true
#
#
# pcall(vim.cmd, 'colorscheme dracula')
# vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#555555" }) -- Background of floating windows
# vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#00FFFF" }) -- Border color for floating windows
