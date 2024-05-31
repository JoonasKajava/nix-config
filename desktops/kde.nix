{
  pkgs,
  lib,
  plasma-manager,
  user,
  ...
}: {
  services.desktopManager.plasma6.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.enable = true;

  home-manager.users.${user.username} = {
    imports = [plasma-manager.homeManagerModules.plasma-manager];

    programs.plasma = {
      enable = true;
      workspace = {
        theme = "breeze-dark";
        colorScheme = "BreezeDark";
        wallpaper = ../assets/images/desktop-bg.png;
      };
    };
  };
}
