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
      (python3.withPackages (p: with p; [
        pytest
        numpy
        pandas
        matplotlib
      ]))
    ];

    lumi.apps.jetbrains.ide.pycharm = true;
    lumi.apps.kdenlive.enable = true;

    lumi.apps.onlyoffice.enable = true;

    networking.networkmanager.plugins = [
      pkgs.networkmanager-openvpn
    ];
  };
}
