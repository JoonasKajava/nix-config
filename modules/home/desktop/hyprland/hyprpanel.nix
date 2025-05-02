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
    systemd.enable = true;
    hyprland.enable = true;
    override.enable = true;

    theme = "catppuccin_mocha";

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

    settings = {
      bar = {
        clock = {
          format = "%a %b %d  %H:%M:%S";
        };
      };
    };
  };
}
