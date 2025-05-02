{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  useWayland = true;
in {
  config = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    environment.systemPackages = [
      pkgs.sddm-astronaut
    ];

    services.xserver.enable = !useWayland;

    services.displayManager = {
      defaultSession = "hyprland-uwsm";

      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [sddm-astronaut];
        wayland = {
          enable = useWayland;
          compositor = "kwin";
        };
        theme = "sddm-astronaut-theme";
      };
    };
  };
}
