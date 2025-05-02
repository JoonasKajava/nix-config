{
  lib,
  config,
  namespace,
  inputs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    enable = true;
    hyprland.enable = true;
    override.enable = true;

    settings = {
      scalingPriority = "hyprland";
      theme.name = "catppuccin_mocha";
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
        launcher.autoDetectIcon = true;
        workspaces.show_numbered = true;
        workspaces.workspaces = 9;
        clock = {
          format = "%a %b %d  %H:%M:%S";
        };
      };
    };
  };
}
