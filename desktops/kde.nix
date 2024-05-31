{
  pkgs,
  lib,
  plasma-manager,
  user,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "joonas";
    sddm = {
      enable = true;
    };
  };

  services.xserver.desktopManager.plasma5.enable = true;

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
