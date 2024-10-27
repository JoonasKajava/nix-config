{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.gaming.warhammer;
in {
  options.mystuff.gaming.warhammer = {
    enable = mkEnableOption "warhammer related stuff";
  };

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
