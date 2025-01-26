{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.printing;
in {
  options.mystuff.printing = {
    enable = mkEnableOption "printing";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [
          hplip
        ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
