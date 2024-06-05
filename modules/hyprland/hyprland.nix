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
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    environment.systemPackages = with pkgs; [
      kitty
    ];

    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland.override {
        debug = true;
      };
      xwayland.enable = true;
    };

    home-manager.users.${user.username} = {config, ...}: {
      xdg.configFile."hypr/hyprland.conf".source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/modules/hyprland/hyprlandd.conf";
    };
  };
}
