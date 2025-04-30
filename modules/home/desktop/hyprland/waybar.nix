{
  lib,
  config,
  namespace,
  ...
}: {
  # TODO: Replace with Eww
  programs.waybar = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    enable = true;
    settings = {
    };
  };
}
