{ pkgs, lib, user, ... }: {
  home-manager.users.${user.username} = with home-manager; {
    programs.neovim = {
      vimAlias = true;
      enable = true;
      viAlias = true;
    };
    xdg.configFile.nvim = {
      source = home-manager.config.lib.file.mkOutOfStoreLink "/etc/nixos/features/programs/neovim/lazyvim";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.variables.EDITOR = "nvim";
}