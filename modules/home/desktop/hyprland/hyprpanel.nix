  {
    den.aspects.desktop.hyprland.homeManager = {osConfig,pkgs, lib, ...}: {
      xdg.configFile = {
        hyprpanel.force = true;
      };

      programs.hyprpanel = {
        enable = true;
        systemd.enable = true;

        settings = {
          scalingPriority = "hyprland";
          theme = {
            name = "catppuccin_mocha";
          };
          menus = {
            clock.weather = {
              key = osConfig.sops.secrets.weather_api.path;
              location = "Kerava";
              unit = "metric";
            };
            dashboard.shortcuts.left = {
              shortcut1 = {
                command = "steam";
                tooltip = "Steam";
                icon = "";
              };
              shortcut2 = {
                command = lib.getExe pkgs.mission-center;
                tooltip = "Mission Center";
                icon = "";
              };
              shortcut4 = {
                command = lib.getExe pkgs.anyrun;
              };
            };
          };
          layout = {
            "bar.layouts" = {
              "*" = {
                left = ["dashboard" "workspaces" "windowtitle"];
                middle = ["weather" "clock" "notifications"];
                right = [
                  "systray"
                  "kbinput"
                  "volume"
                  "microphone"
                  "network"
                  "bluetooth"
                ];
              };
            };
          };
          bar = {
            customModules.weather.unit = "metric";
            launcher.autoDetectIcon = true;
            workspaces.show_numbered = true;
            workspaces.workspaces = 9;
            clock = {
              format = "%a %b %d  %H:%M:%S";
            };
          };
        };
      };
    };
  }
