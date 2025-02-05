{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable = mkEnableOption "Whether to install the hyprland";
  };

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {config, ...}: {
      xdg.configFile."hypr/hyprlandd.conf".source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/modules/nixos/desktop/hyprland/hyprlandd.conf";
    };
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
  };
}
