{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.audio.easyeffects;
in {
  options.mystuff.audio.easyeffects = {
    enable = mkEnableOption "Enable Easyeffects";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      easyeffects
    ];
  };
}
