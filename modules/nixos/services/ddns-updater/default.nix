{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;

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


    users.users.ddns-updater = {
      isSystemUser = true;
      group = "ddns-updater";
      description = "Dynamic DNS Updater Service User";
      createHome = false;
    };

    users.groups.ddns-updater = {};

    systemd.services.ddns-updater = {
      after = ["sops-nix.service"];
      serviceConfig = {
        DynamicUser = mkForce false;
        User = "ddns-updater";
        Group = "ddns-updater";
      };
    };
  };
}
