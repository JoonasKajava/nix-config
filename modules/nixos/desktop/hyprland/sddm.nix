{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: {
  config = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    environment.systemPackages = [
      pkgs.sddm-astronaut
    ];

    services.displayManager = {
      defaultSession = "hyprland.desktop";

      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
      };
    };
  };
}
