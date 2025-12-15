{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.school;
in {
  options.${namespace}.school = {enable = mkEnableOption "school";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zoom-us
      vscode
    ];

    networking.networkmanager.plugins = [
      pkgs.networkmanager-openvpn
    ];
  };
}
