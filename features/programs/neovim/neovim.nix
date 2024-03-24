{ pkgs, lib, user, ... }:
{
  home-manager.users.${user.username} = {config,...}: {
    programs.neovim = {
      vimAlias = true;
      enable = true;
      viAlias = true;
    };
    xdg.configFile.nvim = {
      source =  config.lib.file.mkOutOfStoreSymlink  "/etc/nixos/features/programs/neovim/lazyvim";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

environment = {
  variables.EDITOR = "nvim";
  systemPackages = with pkgs; [
    gcc ripgrep lazygit cargo 

    # Used with tex files
    texliveFull
    texlab



  ];
};

  fonts.packages = with pkgs; [
    nerdfonts
  ];
}
