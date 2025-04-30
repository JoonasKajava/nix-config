{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  # TODO: Fix wayland
  useWayland = false;
in {
  config = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    environment.systemPackages = [
      pkgs.sddm-astronaut
    ];

    services.xserver.enable = !useWayland;

    services.displayManager = {
      defaultSession = "hyprland-uwsm";

      sddm = {
        extraPackages = lib.mkIf useWayland [
          pkgs.kdePackages.layer-shell-qt
          pkgs.libsForQt5.layer-shell-qt
        ];
        settings = lib.mkIf useWayland {
          General = {
            DisplayServer = "wayland";
            GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
          };
        };
        enable = true;
        wayland.enable = useWayland;
        theme = "sddm-astronaut-theme";
      };
    };
  };
}
