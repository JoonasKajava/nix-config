{ pkgs, lib, user, home-manager, ... }:
let
lazyvim = home-manager.config.lib.file.mkOutOfStoreLink "/etc/nixos/features/programs/neovim/lazyvim";
in
{
  home-manager.users.${user.username} = {
    programs.neovim = {
      vimAlias = true;
      enable = true;
      viAlias = true;
    };
    xdg.configFile.nvim = {
      source = lazyvim;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.variables.EDITOR = "nvim";
}