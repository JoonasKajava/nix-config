{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.firefly-iii;
in {
  options.${namespace}.services.firefly-iii = {
    enable = mkEnableOption "Whether to enable firefly-iii";
    host = mkOption {
      type = lib.types.str;
      default = "firefly.joonaskajava.com";
      description = "The host name for the firefly-iii service";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      config.services.firefly-iii.dataDir
    ];

    sops.secrets.firefly-iii-app-key = {
      owner = "firefly-iii";
    };

    services.firefly-iii = {
      enable = true;
      package = pkgs.stable.firefly-iii;
      group = "caddy";
      settings = {
        APP_URL = "https://${cfg.host}";
        APP_KEY_FILE = config.sops.secrets.firefly-iii-app-key.path;
      };
    };

    services = {
      caddy.virtualHosts."${cfg.host}" = {
        extraConfig = ''
          encode gzip
          file_server
          root * ${config.services.firefly-iii.package}/public
          php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket}
          import cloudflare
        '';
      };
    };
  };
}
