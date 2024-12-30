{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.mystuff.terminal.zellij;
in {
  options.mystuff.terminal.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.username} = {
      programs.zellij = {
        enable = true;
        settings = {
        };
      };
    };
  };
}
