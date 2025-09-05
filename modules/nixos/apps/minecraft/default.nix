{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.minecraft;
in {
  options.${namespace}.apps.minecraft = {
    enable = mkEnableOption "minecraft";
    openServerPorts = mkEnableOption "open server ports for minecraft";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      ftb-app
    ];

    networking.firewall = lib.mkIf cfg.openServerPorts {
      allowedTCPPorts = [25565];
      allowedUDPPorts = [25565];
    };
  };
}
