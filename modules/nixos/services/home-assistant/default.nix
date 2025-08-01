{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;

  cfg = config.${namespace}.services.home-assistant;
in {
  options.${namespace}.services.home-assistant = {
    enable = mkEnableOption "Whether to enable home assistant services";
    host = mkOption {
      type = lib.types.str;
      default = "home-assistant.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    services.caddy.virtualHosts."${cfg.host}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.home-assistant.config.http.server_port}
        import cloudflare
      '';
    };
    registery.importantDirs = [
      config.services.home-assistant.configDir
    ];
    services.home-assistant = {
      enable = true;
      package = pkgs.stable.home-assistant;
      lovelaceConfigWritable = true;
      configWritable = true;
      extraComponents = [
        "default_config"
        "met"
        "esphome"
        "androidtv"
        "alert"
        "bluetooth"
        "browser"
        "calendar"
        "camera"
        "command_line"
        "wake_on_lan"
        "withings"
        "tplink"
        "tplink_tapo"
        "mobile_app"
      ];
      config = {
        default_config = {};
        homeassistant = {
          unit_system = "metric";
        };
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
          ];
        };
      };
    };
  };
}
