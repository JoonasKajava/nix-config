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
      secrets = {
        home-assistant-api = {
          restartUnits = ["homepage-dashboard.service"];
        };
        paperless-api = {};
        forgejo-api = {};
      };
      templates = {
        "homepage-env" = {
          restartUnits = ["homepage-dashboard.service"];
          content = ''
            HOMEPAGE_VAR_IMMICH_API=${config.sops.placeholder."immich-api"}
            HOMEPAGE_VAR_KARAKEEP_API=${config.sops.placeholder."karakeep-api"}
            HOMEPAGE_VAR_MEALIE_API=${config.sops.placeholder."mealie-api"}
            HOMEPAGE_VAR_CHANGEDETECTION_API=${config.sops.placeholder."changedetection-api"}
            HOMEPAGE_VAR_UPTIME_KUMA_API=${config.sops.placeholder."uptime-kuma-api"}
            HOMEPAGE_VAR_HOME_ASSISTANT_API=${config.sops.placeholder."home-assistant-api"}
            HOMEPAGE_VAR_PAPERLESS_API=${config.sops.placeholder."paperless-api"}
            HOMEPAGE_VAR_FORGEJO_API=${config.sops.placeholder."forgejo-api"}
          '';
        };
      };
    };

    services.homepage-dashboard = {
      enable = true;
      allowedHosts = cfg.host;
      environmentFiles = [config.sops.templates."homepage-env".path];
      settings = {
        title = "Homepage Dashboard";
        #background = "";
        theme = "dark";
        layout = {
          "Services" = {
            style = "row";
            columns = 4;
          };
        };
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
            {
              "Uptime Kuma" = rec {
                icon = mkIcon "uptime-kuma";
                href = "https://uptime.joonaskajava.com";
                description = "Self-hosted status monitoring solution";
                widget = {
                  type = "uptimekuma";
                  url = href;
                  slug = "all";
                };
              };
            }
            {
              "Home Assistant" = rec {
                icon = mkIcon "home-assistant";
                href = "https://home-assistant.joonaskajava.com";
                description = "Home automation platform";
                widget = {
                  type = "homeassistant";
                  url = href;
                  key = "{{HOMEPAGE_VAR_HOME_ASSISTANT_API}}";
                };
              };
            }
            {
              "Paperless" = rec {
                icon = mkIcon "paperless-ngx";
                href = "https://paperless.joonaskajava.com";
                description = "Document management system";
                widget = {
                  type = "paperlessngx";
                  url = href;
                  key = "{{HOMEPAGE_VAR_PAPERLESS_API}}";
                };
              };
            }
            {
              "MySpeed" = mkIf false rec {
                icon = mkIcon "myspeed";
                href = "https://myspeed.joonaskajava.com";
                description = "Self-hosted internet speed test";
                widget = {
                  type = "myspeed";
                  url = href;
                };
              };
            }
            {
              "Forgejo" = rec {
                icon = mkIcon "forgejo";
                href = "https://forgejo.joonaskajava.com";
                description = "Self-hosted Git service";
                widget = {
                  type = "gitea";
                  url = href;
                  key = "{{HOMEPAGE_VAR_FORGEJO_API}}";
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
