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
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set-option -g base-index 1
        set -g renumber-windows on

        set -s escape-time 0
      '';
    };
  };
}
