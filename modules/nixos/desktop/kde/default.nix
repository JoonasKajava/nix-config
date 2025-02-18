{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.desktop.kde;
in {
  options.${namespace}.desktop.kde = {
    enable = mkEnableOption "Whether to install the KDE desktop environment";
  };

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      ${namespace}.desktop.kde.plasma-manager.enable = true;
    };

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        kate
        elisa
      ];

      systemPackages = with pkgs.kdePackages; [
        kcolorchooser
        filelight
      ];
    };

    services = {
      xserver = {
        enable = true;
      };

      displayManager = {
        autoLogin.enable = true;
        autoLogin.user = config.${namespace}.user.name;
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
