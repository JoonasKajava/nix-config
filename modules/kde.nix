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
    services = {
      xserver = {
        enable = true;
      };

      displayManager = {
        #autoLogin.enable = true;
        #autoLogin.user = "joonas";
        defaultSession = "plasma";
        sddm = {
          wayland.enable = true;
          enable = true;
        };
      };

      desktopManager.plasma6.enable = true;
    };

    #   qt = {
    #     enable = true;
    #    platformTheme = "gnome";
    #   style = "adwaita-dark";
    #  };

    programs.dconf.enable = true;
  };
}
