{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.mangohud;
in {
  options.mystuff.mangohud = {
    enable = mkEnableOption "Enable mangohud";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
