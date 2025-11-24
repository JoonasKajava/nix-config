{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.myspeed;
  homeFolder = "/var/lib/myspeed";
in {
  options.${namespace}.services.myspeed = {
    enable = mkEnableOption "Whether to enable myspeed service";
    address = mkOption {
      type = types.str;
      default = "myspeed.joonaskajava.com";
      example = "localhost";
    };
    internalPort = mkOption {
      type = types.number;
      default = 42371;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      homeFolder
    ];

    systemd.tmpfiles.rules = [
      "d ${homeFolder} 0750 root root -"
      "z ${homeFolder} 0750 root root -"
    ];

    virtualisation = mkIf cfg.enable {
      oci-containers = {
        containers = {
          myspeed = {
            image = "germannewsmaker/myspeed:latest";
            ports = ["${toString cfg.internalPort}:5216/tcp"];
            volumes = [
              "${homeFolder}:/myspeed/data:rw"
            ];
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
