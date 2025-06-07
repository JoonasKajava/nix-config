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

        port = 28981;
        settings = {
          PAPERLESS_OCR_LANGUAGE = "eng+equ+fin+osd+swe";
        };
      };
    };
  };
}
