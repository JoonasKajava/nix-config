{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.gaming.steam;
in {
  #
  # Migrated to Snowfall
  #
  options.mystuff.gaming.steam = {
    enable = mkEnableOption "steam";
    proton-ge.enable = mkOption {
      default = true;
      description = "Enable proton-ge";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;

        extraCompatPackages = lib.optionals cfg.proton-ge.enable (with pkgs; [
          proton-ge-bin
        ]);
      };

      gamemode.enable = true;
    };

    mystuff.mangohud.enable = true;
  };
}
