{
  lib,
  config,
  namespace,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.kitty;
in {
  options.${namespace}.apps.kitty = {
    enable = mkEnableOption "Whether to install kitty";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];

    programs.kitty = {
      enable = true;
      settings = {
        cursor_trail = 3;
        confirm_os_window_close = 0;
        include = "${inputs.kitty-themes}/themes/tokyo_night_moon.conf";
      };
    };
  };
}
