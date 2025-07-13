{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.karakeep;
in {
  options.${namespace}.services.karakeep = {
    enable = mkEnableOption "Whether to enable karakeep service";
    port = mkOption {
      type = types.number;
      default = 38446;
    };
    address = mkOption {
      type = types.str;
      default = "karakeep.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.port}
          import cloudflare
        '';
      };
    };

    registery = {
      importantDirs = [
        "/var/lib/karakeep/"
      ];
    };

    services.karakeep = {
      enable = true;
      extraEnvironment = rec {
        PORT = "${toString cfg.port}";
        DISABLE_SIGNUPS = "true";
        CRAWLER_FULL_PAGE_SCREENSHOT = "true";
        CRAWLER_FULL_PAGE_ARCHIVE = "true";
        MAX_ASSET_SIZE_MB = "100";
        CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = MAX_ASSET_SIZE_MB;
        CRAWLER_VIDEO_DOWNLOAD = "true";
      };
    };
  };
}
