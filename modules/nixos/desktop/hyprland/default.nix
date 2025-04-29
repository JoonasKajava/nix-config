{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals;

  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable = mkEnableOption "Whether to install the hyprland";
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
