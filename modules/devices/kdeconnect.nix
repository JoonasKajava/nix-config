{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.devices.kdeconnect;
in {
  options.mystuff.devices.kdeconnect = {
    enable = mkEnableOption "kdeconnect";
  };

  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}
