{config, pkgs, lib, plasma-manager, ...}:
{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.enable = true;
  config.environment = {
    home-manager.users.joonas = {
      imports = plasma-manager.homeManagerModules.plasma-manager;
      programs.plasma = {
        enable = true;
        workspace = {
          lookAndFeel = "org.kde.breeze.desktop";
        };
      };
    };
  };
}
