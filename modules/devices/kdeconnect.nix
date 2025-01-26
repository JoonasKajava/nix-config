{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.devices.kdeconnect;
in {
  #
  # Migrated to Snowfall
  #
  options.mystuff.devices.kdeconnect = {
    enable = mkEnableOption "kdeconnect";
  };

  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}
