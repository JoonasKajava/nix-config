{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.mangohud;
in {
  options.mystuff.mangohud = {
    enable = mkEnableOption "Enable mangohud";
  };

  # Add mangohud %command% to steam launch options

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
