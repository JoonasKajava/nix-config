{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.generators) toJSON;

  cfg = config.${namespace}.services.immich;
in {
  options.${namespace}.services.immich = {
    enable = mkEnableOption "Whether to enable immich";
    host = mkOption {
      type = lib.types.str;
      default = "immich.joonaskajava.com";
      description = "The host name for the immich service";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      "/var/lib/immich/"
    ];

    users.users.immich.extraGroups = ["video" "render"];
    services.immich = {
      enable = true;
      accelerationDevices = null;
      # I just sops templates to create config file
      settings = null;
      environment = {
        TZ = "Europe/Helsinki";
        IMMICH_CONFIG_FILE = config.sops.templates."immich-config.json".path;
      };
    };

    sops.templates."immich-config.json".content = toJSON {} {
      newVersionCheck.enabled = false;
      server.externalDomain = "https://${cfg.host}";
      notifications.smtp = {
        enabled = true;
        from = "immich@${cfg.host}";
        transport = {
          ignoreCert = false;
          host = config.sops.placeholder."smtp/host";
          port = config.sops.placeholder."smtp/port-starttls";
          username = config.sops.placeholder."smtp/username";
          password = config.sops.placeholder."smtp/app-password";
        };
      };
    };

    systemd.services.immich = {
      after = ["sops-nix.service"];
    };

    services.caddy.virtualHosts."${cfg.host}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.immich.port}
      '';
    };
  };
}
