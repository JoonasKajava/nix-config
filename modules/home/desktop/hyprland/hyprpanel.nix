{
  lib,
  config,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    enable = true;
    hyprland.enable = true;
    override.enable = true;

    settings = {
      scalingPriority = "hyprland";
      theme = {
        name = "catppuccin_mocha";
      };
      menus.dashboard.shortcuts.left = {
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
