{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.vlc;
in {
  options.mystuff.vlc = {
    enable = mkEnableOption "vlc";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vlc
    ];
  };
}
