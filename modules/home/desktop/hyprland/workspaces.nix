{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    workspace = [
      "4, persistent:true, monitor:DP-2, default:true"
      "5, persistent:true, monitor:DP-2"
      "6, persistent:true, monitor:DP-2"

      "1, persistent:true, monitor:HDMI-A-1, default:true"
      "2, persistent:true, monitor:HDMI-A-1"
      "3, persistent:true, monitor:HDMI-A-1"

      "7, persistent:true, monitor:HDMI-A-2, default:true"
      "8, persistent:true, monitor:HDMI-A-2"
      "9, persistent:true, monitor:HDMI-A-2"
    ];
  };
}
