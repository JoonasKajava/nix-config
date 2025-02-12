{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.nvf.settings.vim.filetree.nvim-oil;
in {
  options.programs.nvf.settings.vim.filetree.nvim-oil = {
    enable = lib.mkEnableOption "Whether to enable nvim-oil";
  };

  config.programs.nvf.settings.config.vim.lazy.plugins = lib.mkIf cfg.enable {
    "oil.nvim" = {
      package = pkgs.vimPlugins.oil-nvim;
      setupModule = "oil";
      after = "print('oil loaded')";
      keys = [
        {
          key = "<leader>e";
          action = "<CMD>Oil --float<CR>";
          mode = "n";
        }
      ];
    };
  };
}
