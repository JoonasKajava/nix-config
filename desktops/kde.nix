{
  pkgs,
  lib,
  plasma-manager,
  user,
  ...
}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.enable = true;

  home-manager.users.${user.username} = {
    imports = [plasma-manager.homeManagerModules.plasma-manager];

    programs.plasma = {
      enable = true;
      workspace = {
        theme = "breeze-dark";
        colorScheme = "BreezeDark";
        wallpaper = ../assets/images/desktop-bg.png;
      };
    };
  };
}
