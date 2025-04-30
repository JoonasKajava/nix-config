{
  lib,
  config,
  namespace,
  ...
}: {
  # TODO: Replace with AGS/astal
  programs.waybar = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    enable = true;
    settings = {
    };
  };
}
