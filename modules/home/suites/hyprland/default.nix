{
  lib,
  config,
  namespace,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.suites.hyprland;
in {
  options.${namespace}.suites.hyprland = {
    enable = mkEnableOption "Whether to enable the Hyprland suite." // {default = osConfig.${namespace}.suites.hyprland.enable;};
  };

  config = mkIf cfg.enable {
    lumi = {
      # Wallpapers
      services.swww.enable = true;

      desktop.hyprland.enable = true;
      apps.anyrun.enable = true;

      # Audio control
      apps.pavucontrol.enable = true;
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-hyprcursor;
      name = "rose-pine-hyprcursor";
      size = 24;
      hyprcursor = {
        enable = true;
        size = 24;
      };
    };
  };
}
