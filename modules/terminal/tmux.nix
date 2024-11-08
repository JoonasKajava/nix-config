{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.terminal.tmux;
in {
  options.mystuff.terminal.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      extraConfig = ''
        set-option -g mouse on
      '';
    };
  };
}
