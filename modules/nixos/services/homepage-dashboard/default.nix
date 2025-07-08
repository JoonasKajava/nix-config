{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption mkForce;
  inherit (lib.generators) toYAML;

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
    sops.secrets.immich-api.restartUnits = ["homepage-dashboard.service"];

    # TODO: rewrite to https://github.com/DenzoNL/nixbox.tv/blob/e1b331f6c13629255bf677b1fc28bbdb411abe18/services/homepage.nix#L4
    # this is handled by sops-nix
    environment.etc."homepage-dashboard/widgets.yaml".enable = mkForce false;
    environment.etc."homepage-dashboard/services.yaml".enable = mkForce false;

    services.homepage-dashboard = {
      enable = true;
      allowedHosts = cfg.host;
      settings = {
        title = "Homepage Dashboard";
        #background = "";
        theme = "dark";
      };
    };
    sops.templates = {
      "services.yaml" = {
        restartUnits = ["homepage-dashboard.service"];
        path = "/etc/homepage-dashboard/services.yaml";
        mode = "0440";
        group = "homepage-dashboard";
        content = toYAML {} [
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
                    key = config.sops.placeholder."immich-api";
                    version = 2;
                  };
                };
              }
            ];
          }
        ];
      };
      "widgets.yaml" = {
        restartUnits = ["homepage-dashboard.service"];
        path = "/etc/homepage-dashboard/widgets.yaml";
        mode = "0440";
        group = "homepage-dashboard";
        content = toYAML {} [
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
    };

    users.groups.homepage-dashboard = {};

    users.users.homepage-dashboard = {
      isSystemUser = true;
      group = "homepage-dashboard";
      description = "Homepage Dashboard Service User";
      createHome = false;
    };

    systemd.services.homepage-dashboard = {
      after = ["sops-nix.service"];
      serviceConfig = {
        DynamicUser = mkForce false;
        User = "homepage-dashboard";
        Group = "homepage-dashboard";
      };
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
