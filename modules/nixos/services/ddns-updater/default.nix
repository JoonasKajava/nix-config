{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.ddns-updater;
in {
  options.${namespace}.services.ddns-updater = {
    enable = mkEnableOption "Whether to enable dynamic DNS updater service";
  };

  config = mkIf cfg.enable {
    services.ddns-updater = {
      enable = true;
      environment = {
        TZ = "Europe/Berlin";
        CONFIG_FILEPATH = config.sops.secrets.home-server-ddns-config.path;
        LOG_LEVEL = "debug";
      };
    };

    systemd.services.ddns-updater = {
      after = ["sops-nix.service"];
      # serviceConfig.User = "root";
      # serviceConfig.Group = "root";
    };
  };
}
