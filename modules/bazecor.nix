{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.bazecor;
in {
  options.mystuff.bazecor = {
    enable = mkEnableOption "bazecor";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bazecor
    ];
    users.users.${user.username} = {
      extraGroups = ["dialout"]; # bazecor needs this to access the serial port
    };
  };
}
