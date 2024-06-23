{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.kde;
in {
  options.mystuff.kde = {
    enable = mkEnableOption "Enable kde desktop";
  };

  config = mkIf cfg.enable {
    #
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
  };
}
