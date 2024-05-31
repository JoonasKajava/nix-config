{
  config,
  lib,
  user,
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
    programs.hyprland.enable = true;

    home-manager.users.${user.username} = {config, ...}: {
      xdg.configFile."hypr/hyprland.conf".source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/modules/hyprland/hyprland.conf";
    };
  };
}
