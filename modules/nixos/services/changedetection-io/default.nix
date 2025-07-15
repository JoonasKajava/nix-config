{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.changedetection-io;
in {
  options.${namespace}.services.changedetection-io = {
    enable = mkEnableOption "Whether to enable changedetection-io";
    host = mkOption {
      type = lib.types.str;
      default = "changedetection.joonaskajava.com";
      description = "The host name for the changedetection-io service";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      config.services.changedetection-io.datastorePath
    ];

    services.changedetection-io = {
      enable = true;
      behindProxy = true;
      baseURL = "https://${cfg.host}";
      playwrightSupport = true;
    };

    services = {
      caddy.virtualHosts."${cfg.host}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.changedetection-io.port}
          import cloudflare
        '';
      };
    };
  };
}
