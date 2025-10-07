{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.anki-sync-server;
in {
  options.${namespace}.services.anki-sync-server = {
    enable = mkEnableOption "anki sync server";
    host = mkOption {
      type = lib.types.str;
      default = "anki.joonaskajava.com";
      description = "The host name for the anki-sync-server";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      "/var/lib/anki-sync-server"
    ];
    sops.secrets."anki-user-passwords/joonas" = {
      restartUnits = ["anki-sync-server.service"];
    };
    services = {
      anki-sync-server = {
        enable = true;
        users = [
          {
            username = "joonas";
            passwordFile = config.sops.secrets."anki-user-passwords/joonas".path;
          }
        ];
      };

      caddy.virtualHosts."${cfg.host}" = {
        extraConfig = ''
          reverse_proxy http://[::1]:${toString config.services.anki-sync-server.port}
          import cloudflare
        '';
      };
    };
  };
}
