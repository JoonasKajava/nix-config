{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.donetick;
  homeFolder = "/var/lib/donetick";
in {
  options.${namespace}.services.donetick = {
    enable = mkEnableOption "Whether to enable donetick service";
    address = mkOption {
      type = types.str;
      default = "donetick.joonaskajava.com";
      example = "localhost";
    };
    internalPort = mkOption {
      type = types.number;
      default = 2021;
    };
  };

  config = mkIf cfg.enable {
    virtualisation = mkIf cfg.enable {
      oci-containers = {
        backend = "podman";
        containers = {
          donetick = {
            image = "donetick/donetick:latest";
            ports = ["${builtins.toString cfg.internalPort}:2021/tcp"];
            volumes = [
              "${homeFolder}/data:/donetick-data:rw"
              "${homeFolder}/config:/config:rw"
            ];
            autoStart = true;
            environment = {
              DT_ENV = "selfhosted";
              DT_SQLITE_PATH = "${homeFolder}/data/donetick.db";
            };
            extraOptions = ["--pull=newer"];
          };
        };
      };
    };
    sops.templates."donetick-config.yaml" = {
      restartUnits = ["podman-donetick.service"];
      path = "${homeFolder}/config/selfhosted.yaml";
      content =
        # yaml
        ''
          name: "selfhosted"
          is_done_tick_dot_com: false
          is_user_creation_disabled: true
          database:
            type: "sqlite"
            migration: true
          jwt:
            secret: "${config.sops.placeholder.donetick-swt-secret}"
            session_time: 168h
            max_refresh: 168h
          server:
            port: ${toString cfg.internalPort}
            read_timeout: 10s
            write_timeout: 10s
            rate_period: 60s
            rate_limit: 300
            cors_allow_origins:
              - "http://localhost:5173"
              - "http://localhost:7926"
              # the below are required for the android app to work
              - "https://localhost"
              - "capacitor://localhost"
            serve_frontend: true
          logging:
            level: "info"
            encoding: "json"
            development: false
          scheduler_jobs:
            due_job: 30m
            overdue_job: 3h
            pre_due_job: 3h
          # Real-time configuration
          realtime:
            enabled: true
            websocket_enabled: false
            sse_enabled: true
            heartbeat_interval: 60s
            connection_timeout: 120s
            max_connections: 1000
            max_connections_per_user: 5
            event_queue_size: 2048
            cleanup_interval: 2m
            stale_threshold: 5m
            enable_compression: true
            enable_stats: true
            allowed_origins:
              - "*"
        '';
    };

    registery.importantDirs = [
      homeFolder
    ];

    services = {
      caddy = {
        enable = true;
        virtualHosts = {
          "${cfg.address}".extraConfig = ''
            reverse_proxy http://127.0.0.1:${builtins.toString cfg.internalPort}
          '';
        };
      };
    };
  };
}
