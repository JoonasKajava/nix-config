{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.homepage-dashboard;
  mkIcon = icon: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/${icon}.svg";
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
    sops = {
      templates = {
        "immich-env" = {
          restartUnits = ["homepage-dashboard.service"];
          content = ''
            HOMEPAGE_VAR_IMMICH_API=${config.sops.placeholder."immich-api"}
            HOMEPAGE_VAR_KARAKEEP_API=${config.sops.placeholder."karakeep-api"}
            HOMEPAGE_VAR_MEALIE_API=${config.sops.placeholder."mealie-api"}
            HOMEPAGE_VAR_CHANGEDETECTION_API=${config.sops.placeholder."changedetection-api"}
          '';
        };
      };
    };

    services.homepage-dashboard = {
      enable = true;
      allowedHosts = cfg.host;
      environmentFile = config.sops.templates."immich-env".path;
      settings = {
        title = "Homepage Dashboard";
        #background = "";
        theme = "dark";
      };
      services = [
        {
          "Services" = [
            {
              "Immich" = rec {
                icon = mkIcon "immich";
                href = "https://immich.joonaskajava.com";
                description = "Self-hosted photo and video backup solution";
                widget = {
                  type = "immich";
                  url = href;
                  key = "{{HOMEPAGE_VAR_IMMICH_API}}";
                  version = 2;
                };
              };
            }
            {
              "Karakeep" = rec {
                icon = mkIcon "karakeep";
                href = "https://karakeep.joonaskajava.com";
                description = "Bookmark manager";
                widget = {
                  type = "karakeep";
                  url = href;
                  key = "{{HOMEPAGE_VAR_KARAKEEP_API}}";
                };
              };
            }
            {
              "Mealie" = rec {
                icon = mkIcon "mealie";
                href = "https://mealie.joonaskajava.com";
                description = "Meal planning and recipe management";
                widget = {
                  type = "mealie";
                  url = href;
                  key = "{{HOMEPAGE_VAR_MEALIE_API}}";
                  version = 2;
                };
              };
            }
            {
              "Changedetection.io" = rec {
                icon = mkIcon "changedetection";
                href = "https://changedetection.joonaskajava.com";
                description = "Monitor websites for changes";
                widget = {
                  type = "changedetectionio";
                  url = href;
                  key = "{{HOMEPAGE_VAR_CHANGEDETECTION_API}}";
                };
              };
            }
          ];
        }
      ];
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
