{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.generators) toJSON;

  cfg = config.${namespace}.services.immich;
in {
  options.${namespace}.services.immich = {
    enable = mkEnableOption "Whether to enable immich";
    host = mkOption {
      type = lib.types.str;
      default = "immich.joonaskajava.com";
      description = "The host name for the immich service";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      "/var/lib/immich/"
    ];
    users.users.immich = {
      extraGroups = ["video" "render"];
      home = "/var/lib/immich";
      createHome = true;
    };

    services = {
      postgresql.package = pkgs.postgresql_17;

      immich = {
        enable = true;
        package = pkgs.immich.override {
          vips = pkgs.vips.overrideAttrs (prev: {
            mesonFlags = prev.mesonFlags ++ ["-Dtiff=disabled"];
          });
        };
        accelerationDevices = null;
        #database.enableVectors = true;
        # I just sops templates to create config file
        settings = null;
        environment = {
          TZ = "Europe/Helsinki";
          IMMICH_CONFIG_FILE = config.sops.templates."immich-config.json".path;
        };
      };
      caddy.virtualHosts."${cfg.host}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.immich.port}
          import cloudflare
        '';
      };
    };
    sops.templates."immich-config.json" = {
      inherit (config.services.immich) group;
      owner = config.services.immich.user;

      content = toJSON {} {
        newVersionCheck.enabled = false;
        server.externalDomain = "https://${cfg.host}";
        notifications.smtp = {
          enabled = true;
          from = "immich@${cfg.host}";
          transport = {
            ignoreCert = false;
            host = config.sops.placeholder."smtp/host";
            port = 587;
            username = config.sops.placeholder."smtp/username";
            password = config.sops.placeholder."smtp/app-password";
          };
        };
      };
    };

    systemd.services.immich = {
      after = ["sops-nix.service"];
    };
  };
}
