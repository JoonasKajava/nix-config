{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable = mkEnableOption "Whether to install the hyprland";
    autostart = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        A list of packages to autostart.
        Each entry in the list is a package that
        will be started when hyprland starts.'';
    };
  };

  imports = [
    ./sddm.nix
  ];

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
