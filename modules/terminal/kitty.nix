{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.terminal.kitty;
in {
  options.mystuff.terminal.kitty = {
    enable = mkEnableOption "kitty";
    disableOtherTerminals = mkOption {
      type = types.bool;
      default = true;
    };
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    home-manager.users.${user.username} = {config, ...}: {
      programs.kitty = {
        enable = true;
        settings = {
          cursor_trail = 3;
        };
      };
    };

    environment.plasma6.excludePackages = mkIf cfg.disableOtherTerminals (
      with pkgs.kdePackages; [
        konsole
      ]
    );
  };
}
