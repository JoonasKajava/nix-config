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
  #
  # Migrated to Snowfall
  #

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [
          gamemode
        ];
      })
      wine
      winetricks
      # umu-launcher
      protonup-qt
    ];
  };
}
