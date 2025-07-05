{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.generators) toJSON;

  cfg = config.${namespace}.services.homepage-dashboard;
in {
  options.${namespace}.services.homepage-dashboard = {
    enable = mkEnableOption "Whether to enable homepage";
    host = mkOption {
      type = lib.types.str;
      default = "homepage.joonaskajava.com";
      description = "The host name for the homepage service";
    };
  };

  config = mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      allowedHosts = cfg.host;
    };

    ${namespace}.services.caddy.enable = true;

    services.caddy = {
      virtualHosts."${cfg.host}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.homepage-dashboard.listenPort}
          import cloudflare
        '';
      };
    };
  };
}
