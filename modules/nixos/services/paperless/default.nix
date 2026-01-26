{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.paperless;
in {
  options.${namespace}.services.paperless = {
    enable = mkEnableOption "Whether to enable paperless service";
    paperless-ai = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Whether to enable paperless ai service";
          port = mkOption {
            type = types.number;
            default = 3000;
          };
          address = mkOption {
            type = types.str;
            default = "paperless-ai.joonaskajava.com";
          };
        };
      };
    };

    address = mkOption {
      type = types.str;
      default = "paperless.joonaskajava.com";
    };

    gotenbergPort = mkOption {
      type = types.number;
      default = 43467;
    };
  };

  config = mkIf cfg.enable {
    lumi.services.samba.enable = true;

    virtualisation = mkIf cfg.paperless-ai.enable {
      oci-containers = {
        backend = "podman";

        containers = {
          paperless-ai = {
            image = "clusterzx/paperless-ai:latest";
            ports = ["${builtins.toString cfg.paperless-ai.port}:3000/tcp"];
            volumes = [
              "/var/lib/paperless/paperless-ai:/app/data:rw"
            ];
            autoStart = true;
            extraOptions = ["--pull=newer" "--network=host"];
          };
        };
      };
    };

    registery = {
      importantDirs = [
        "/var/lib/paperless/"
        "/var/lib/paperless/paperless-ai/"
      ];
    };

    # Paperless blocks shutdown way too often, so we set a reasonable timeout
    # systemd.services.paperless-task-queue.serviceConfig.TimeoutSec = 15;

    services = {
      caddy = {
        enable = true;
        enableCloudflareIntegration = true;
        virtualHosts = {
          "${cfg.address}".extraConfig = ''
            reverse_proxy http://127.0.0.1:${builtins.toString config.services.paperless.port}
            import cloudflare
          '';
          "${cfg.paperless-ai.address}".extraConfig = ''
            reverse_proxy http://127.0.0.1:${builtins.toString cfg.paperless-ai.port}
            import cloudflare
          '';
        };
      };

      gotenberg = {
        port = cfg.gotenbergPort;
      };
      paperless = {
        inherit (cfg) enable;

        consumptionDir = config.${namespace}.services.samba.printerPath;

        port = 28981;
        domain = cfg.address;
        configureTika = true;
        settings = {
          PAPERLESS_OCR_LANGUAGE = "eng+fin+swe";
          PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://localhost:${toString config.services.gotenberg.port}";
        };
      };
    };
  };
}
