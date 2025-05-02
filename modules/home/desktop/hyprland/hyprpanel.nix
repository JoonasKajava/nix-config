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

    #TODO: do i need overlay.enable = true?

    theme = "catppuccin_mocha";

    settings = {
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
              "power"
            ];
          };
        };
      };
      bar = {
        clock = {
          format = "%a %b %d  %H:%M:%S";
        };
      };
    };
  };
}
