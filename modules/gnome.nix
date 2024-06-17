{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.gnome;
in {
  options.mystuff.gnome = {
    enable = mkEnableOption "Enable gnome desktop";
  };

  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs.gnomeExtensions; [
      appindicator
      tray-icons-reloaded
      vitals
      wayland-or-x11
    ];
  };
}
