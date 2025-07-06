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
      settings = {
        title = "Homepage Dashboard";
        #background = "";
        theme = "dark";
      };
      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
            cputemp = true;
            tempmin = 0;
            tempmax = 100;
            uptime = true;
            units = "metric";
            refresh = 1000;
          };
        }
        {
          search = {
            provider = "google";
            focus = true;
            showSearchSuggestions = true;
            target = "_self";
          };
        }
        {
          datetime = {
            text_size = "x1";
            locale = "fi";
            format = {
              timeStyle = "medium";
              dateStyle = "short";
              hour12 = false;
            };
          };
        }
      ];
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
