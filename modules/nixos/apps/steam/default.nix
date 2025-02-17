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
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      gamemode.enable = true;
    };
  };
}
