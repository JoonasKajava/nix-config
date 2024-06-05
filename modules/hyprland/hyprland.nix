{
  config,
  lib,
  user,
  pkgs,
  ...
}
:
with lib; let
  cfg = config.mystuff.hyprland;
in {
  options.mystuff.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      CLUTTER_BACKEND = "wayland";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      TERMINAL = "kitty";
      # WLR_RENDERER = "vulkan";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_VRR_ALLOWED = "1";
    };

    environment.systemPackages = with pkgs; [
      kitty
      waybar
    ];

    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland.override {
        debug = true;
      };
      xwayland.enable = true;
    };

    home-manager.users.${user.username} = {config, ...}: {
      xdg.configFile."hypr/hyprlandd.conf".source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/modules/hyprland/hyprland.conf";
    };
  };
}
