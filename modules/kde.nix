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

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        kate
        elisa
      ];

      systemPackages = with pkgs; [
        kdePackages.kcolorchooser
      ];
    };

    services = {
      xserver = {
        enable = true;
      };

      displayManager = {
        autoLogin.enable = true;
        autoLogin.user = user.username;
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
