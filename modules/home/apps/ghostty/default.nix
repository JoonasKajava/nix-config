{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.ghostty;
in {
  options.${namespace}.apps.ghostty = {
    enable = mkEnableOption "Whether to install ghostty";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        #theme = "Kitty Default";
        theme = "TokyoNight Night";
        custom-shader = [
          "${./shaders/cursor_smear.glsl}"
        ];
      };

    };
  };
}
