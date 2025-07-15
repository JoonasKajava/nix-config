{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.uptime-kuma;
in {
  options.${namespace}.services.uptime-kuma = {
    enable = mkEnableOption "Whether to enable uptime kuma service";
    address = mkOption {
      type = types.str;
      default = "uptime.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      enableCloudflareIntegration = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.uptime-kuma.settings.PORT}
          import cloudflare
        '';
      };
    };

    registery = {
      importantDirs = [
        config.services.uptime-kuma.settings.DATA_DIR
      ];
    };

    services.uptime-kuma = {
      enable = true;
      settings = {
        UPTIME_KUMA_DB_TYPE = "sqlite";
      };
    };
  };
}
