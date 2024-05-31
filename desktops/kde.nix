{
  pkgs,
  lib,
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
}
