{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.easyeffects;
in {
  options.${namespace}.apps.easyeffects = {
    enable = mkEnableOption "Whether to install easyeffects";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      easyeffects
    ];
    # ${namespace}.desktop.hyprland.autostart = [
    #   "easyeffects --gapplication-service"
    # ];
  };
}
