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
    # Wallpapers
    lumi.services.swww.enable = true;

    lumi.desktop.hyprland.enable = true;

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
