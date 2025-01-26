{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.discord;
in {
  options.mystuff.discord = {
    enable = mkEnableOption "Enable Discrod";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
