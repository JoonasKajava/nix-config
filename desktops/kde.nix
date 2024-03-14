{pkgs, lib, plasma-manager, ...}:
{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.enable = true;
  home-manager.users.joonas = {
    imports = [ plasma-manager.homeManagerModules.plasma-manager ];
    programs.plasma = {
      enable = true;
      workspace = {
        theme = "breeze-dark";
        colorScheme = "BreezeDark";
      };
    };
  };
}
