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
      type = types.listOf types.str;
      default = [];
      description = ''
        List of commands to run on startup.
      '';
    };
  };

  imports = [
    ./sddm.nix
  ];

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      # TODO: I need this, but for now obsidian won't start with it
      # NIXOS_OZONE_WL = "1";
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
