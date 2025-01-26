{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.office;
in {
  options.mystuff.office = {
    enable = mkEnableOption "Office";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}
