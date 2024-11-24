{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.gaming.wow;
in {
  options.mystuff.gaming.wow = {
    enable = mkEnableOption "wow";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wowup-cf
    ];
  };
}
