{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.steam.warhammer;
in {
  options.${namespace}.apps.steam.warhammer = {enable = mkEnableOption "warhammer game configurations";};

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedUDPPorts = [27015];
      allowedUDPPortRanges = [
        {
          from = 27031;
          to = 27036;
        }
      ];
      allowedTCPPorts = [27015 27027 27036];
    };
  };
}
