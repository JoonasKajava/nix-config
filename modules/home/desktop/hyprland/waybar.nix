{
  lib,
  config,
  namespace,
  ...
}: {
  programs.waybar = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    enable = true;
    settings = {
    };
  };
}
