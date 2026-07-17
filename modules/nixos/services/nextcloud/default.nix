{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.nextcloud;
  homeFolder = "/var/lib/nextcloud";
  aioPort = 33311;
in {
  options.${namespace}.services.nextcloud = {
    enable = mkEnableOption "Whether to enable nextcloud service";
    address = mkOption {
      type = types.str;
      default = "nextcloud.joonaskajava.com";
      example = "localhost";
    };
    internalPort = mkOption {
      type = types.number;
      default = 41635;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      homeFolder
    ];
    systemd.tmpfiles.rules = [
      "d ${homeFolder} 0750 root root -"
    ];
    virtualisation = mkIf cfg.enable {
      oci-containers = {
        containers = {
          nextcloud-aio-mastercontainer = {
            pull = "always";
            serviceName = "nextcloud-aio-mastercontainer";
            image = "ghcr.io/nextcloud-releases/all-in-one:latest";
            ports = ["${toString aioPort}:8080/tcp"];
            volumes = [
              "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
              "/var/run/docker.sock:/var/run/docker.sock:ro"
            ];

            autoRemoveOnStop = false;
            environment = {
              TZ = "Europe/Berlin";
              APACHE_PORT = toString cfg.internalPort;
              APACHE_IP_BINDING = "127.0.0.1";
              NEXTCLOUD_DATADIR = homeFolder;
              APACHE_ADDITIONAL_NETWORK = "";
            };
            autoStart = true;
            extraOptions = [
              "--init"
              "--sig-proxy=false"
              "--restart=always"
              "--network=host"
            ];
          };
        };
      };
    };
    services.caddy = {
      enable = true;
      enableCloudflareIntegration = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy 127.0.0.1:${toString cfg.internalPort}
          import cloudflare
        '';

        "nextcloud-aio.joonaskajava.com".extraConfig = ''
          reverse_proxy 127.0.0.1:${toString aioPort} {
              transport http {
                  tls
                  tls_insecure_skip_verify
              }
          }
          import cloudflare
        '';
      };
    };
  };
}
