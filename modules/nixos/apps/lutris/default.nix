{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.lutris;
in {
  options.${namespace}.apps.lutris = {enable = mkEnableOption "lutris";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      umu-launcher
      protonup-qt
    ];
  };
}
