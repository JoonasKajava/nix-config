{
  lib,
  config,
  namespace,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable =
      mkEnableOption "Whether to control hyprland with home manager"
      // {
        default = osConfig.${namespace}.desktop.hyprland.enable;
      };
  };

  config =
    mkIf cfg.enable {
    };
}
