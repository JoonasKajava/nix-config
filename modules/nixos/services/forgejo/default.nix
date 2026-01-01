{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.forgejo;
in {
  options.${namespace}.services.forgejo = {
    enable = mkEnableOption "Whether to enable forgejo service";
    address = mkOption {
      type = types.str;
      default = "forgejo.joonaskajava.com";
      example = "localhost";
    };
    port = mkOption {
      type = types.number;
      default = 38131;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      config.services.forgejo.stateDir
    ];

    services.forgejo = {
      enable = true;
      package = pkgs.stable.forgejo-lts;
      lfs.enable = true;
      database.type = "sqlite3";
      settings.server = {
        HTTP_PORT = cfg.port;
        ROOT_URL = "https://${cfg.address}";
      };
    };

    services.caddy = {
      enable = true;
      enableCloudflareIntegration = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}
          import cloudflare
        '';
      };
    };
  };
}
