{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.apps.onlyoffice;
in
  with lib; {
    options.${namespace}.apps.onlyoffice = {
      enable = mkEnableOption "Whether to install onlyoffice";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        onlyoffice-desktopeditors
      ];
    };
  }
