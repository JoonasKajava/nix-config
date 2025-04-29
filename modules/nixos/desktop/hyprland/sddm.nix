{
  lib,
  config,
  pkgs,
  ...
}: {
  config.environment.systemPackages = [
    pkgs.sddm-astronaut
  ];

  config.services.displayManager = {
    defaultSession = "hyprland.desktop";

    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
    };
  };
}
