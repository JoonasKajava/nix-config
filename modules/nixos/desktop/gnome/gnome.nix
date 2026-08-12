{
  den.aspects.desktop.gnome = {
    nixos = {pkgs, ...}: {
      services.xserver = {
        # Enable the X11 windowing system.
        enable = true;

        # Enable the GNOME Desktop Environment.
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        desktopManager.gnome.enable = true;
      };

      environment.systemPackages = with pkgs.gnomeExtensions; [
        appindicator
        tray-icons-reloaded
        vitals
        wayland-or-x11
      ];
    };
  };
}
