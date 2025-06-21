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
        };
      };
    };

    localOnly = mkEnableOption "Whether to configure paperless for local access only";
    address = mkOption {
      type = types.str;
      default = "paperless";
      example = "localhost";
    };
  };

  config = mkIf cfg.enable {
    networking.hosts = mkIf cfg.localOnly {
      "127.0.0.1" = [cfg.address];
    };

    lumi.services.samba.enable = true;

    virtualisation = mkIf cfg.paperless-ai.enable {
      docker.enable = true;

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

    services = {
      caddy = mkIf (!cfg.localOnly) {
        enable = true;
        virtualHosts = {
          "${cfg.address}".extraConfig = ''
            reverse_proxy http://127.0.0.1:${builtins.toString config.services.paperless.port}
          '';
        };
      };

      paperless = {
        inherit (cfg) enable;
        package = pkgs.stable.paperless-ngx;

        consumptionDir = config.${namespace}.services.samba.printerPath;

        port = 28981;
        settings = {
          PAPERLESS_OCR_LANGUAGE = "eng+fin+swe";
        };
      };
    };
  };
}
