{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.ghostty;
in {
  options.${namespace}.apps.ghostty = {
    enable = mkEnableOption "Whether to install ghostty";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "FiraMono Nerd Font Mono";
        #theme = "Kitty Default";
        #theme = "TokyoNight Night";
        theme = "TokyoNight Moon";
        custom-shader = [
          "${./shaders/cursor_smear.glsl}"
        ];
      };

    };
  };
}
