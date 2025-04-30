{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: {
  config = lib.mkIf config.${namespace}.desktop.hyprland.enable {
    environment.systemPackages = [
      #pkgs.sddm-astronaut
    ];

    services.displayManager = {
      defaultSession = "hyprland-uwsm";

      sddm = {
        extraPackages = [
          pkgs.kdePackages.layer-shell-qt
        ];
        settings = {
          General = {
            DisplayServer = "wayland";
            GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
          };
        };
        enable = true;
        wayland.enable = true;
        #theme = "sddm-astronaut-theme";
      };
    };
  };
}
