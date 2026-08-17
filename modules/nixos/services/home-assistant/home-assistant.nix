{den, ...}: {
  den.aspects.home-assistant = {
    includes = [
      den.aspects.caddy
    ];

    backup.patterns = {config,...}: [
      "+ ${config.services.home-assistant.configDir}"
    ];
    nixos = {
      pkgs,
      config,
      ...
    }: let
      host = "home-assistant.joonaskajava.com";
    in {
      services.caddy.virtualHosts."${host}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.home-assistant.config.http.server_port}
          import cloudflare
        '';
      };
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
  };
}
