{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.wallos;
  homeFolder = "/var/lib/wallos";
in {
  options.${namespace}.services.wallos = {
    enable = mkEnableOption "Whether to enable wallos service";
    address = mkOption {
      type = types.str;
      default = "wallos.joonaskajava.com";
      example = "localhost";
    };
    internalPort = mkOption {
      type = types.number;
      default = 8282;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      homeFolder
    ];
    virtualisation = mkIf cfg.enable {
      oci-containers = {
        containers = {
          wallos = {
            image = "bellamy/wallos:latest";
            ports = ["${toString cfg.internalPort}:80/tcp"];
            volumes = [
              "${homeFolder}/db:/var/www/html/db:rw"
              "${homeFolder}/logos:/var/www/html/images/uploads/logos:rw"
            ];
            environment = {
              TZ = "Europe/Berlin";
            };
            autoStart = true;
            extraOptions = ["--pull=newer"];
          };
        };
      };
    };
    services.caddy = {
      enable = true;
      enableCloudflareIntegration = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.internalPort}
          import cloudflare
        '';
      };
    };
  };
}
