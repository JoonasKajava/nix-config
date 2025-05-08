{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.suites.hyprland;
in {
  options.${namespace}.suites.hyprland = {
    enable = mkEnableOption "Whether to enable the Hyprland suite.";
  };

  config = mkIf cfg.enable {
    # Wallpapers
    lumi.services.swww.enable = true;
  };
}
