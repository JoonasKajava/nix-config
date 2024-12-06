{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.gaming.heroic;
in {
  options.mystuff.gaming.heroic = {
    enable = mkEnableOption "Heroic Games launcher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic
    ];
  };
}
