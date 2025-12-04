{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.changedetection-io;
  dataDir = "/var/lib/changedetection-io";
in {
  options.${namespace}.services.changedetection-io = {
    enable = mkEnableOption "Whether to enable changedetection-io";
    host = mkOption {
      type = lib.types.str;
      default = "changedetection.joonaskajava.com";
      description = "The host name for the changedetection-io service";
    };

    port = mkOption {
      type = types.number;
      default = 33253;
    };

    playwright-port = mkOption {
      type = types.number;
      default = 33937;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      dataDir
    ];
    virtualisation.oci-containers.containers = {
      changedetection-io = {
        image = "dgtlmoon/changedetection.io:latest";
        ports = ["${builtins.toString cfg.port}:5000/tcp"];
        volumes = [
          "${dataDir}:/datastore:rw"
        ];
        autoStart = true;
        extraOptions = ["--pull=newer"];
        environment = {
          PLAYWRIGHT_DRIVER_URL = "ws://host.containers.internal:${builtins.toString cfg.playwright-port}";
          BASE_URL = "https://${cfg.host}";
        };
      };

      changedetection-io-playwright = {
        image = "dgtlmoon/sockpuppetbrowser:latest";
        ports = ["${builtins.toString cfg.playwright-port}:3000/tcp"];
        autoStart = true;
        extraOptions = ["--pull=newer"];
        environment = {
          SCREEN_WIDTH = "1920";
          SCREEN_HEIGHT = "1024";
          SCREEN_DEPTH = "16";
          MAX_CONCURRENT_CHROME_PROCESSES = "10";
          CHROME_OPTIONS = "--window-size=1280,1024 --headless --disable-gpu";
        };
      };
    };
    services = {
      caddy.virtualHosts."${cfg.host}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
          import cloudflare
        '';
      };
    };
  };
}
