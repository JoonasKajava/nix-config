{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.gaming.lutris;
in {
  options.mystuff.gaming.lutris = {
    enable = mkEnableOption "lutris";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      protonup-qt
    ];
  };
}
