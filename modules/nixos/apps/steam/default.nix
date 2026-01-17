{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.steam;
in {
  options.${namespace}.apps.steam = {enable = mkEnableOption "steam";};

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      PROTON_FSR4_UPGRADE = "1";
      PROTON_XESS_UPGRADE = "1";
      PROTON_ENABLE_WAYLAND = "1";
    };

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = false;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      gamemode.enable = true;
    };
  };
}
