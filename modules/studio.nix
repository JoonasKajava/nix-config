{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.studio;
in {
  options.mystuff.studio = {
    enable = mkEnableOption "Enable studio applications";

    audio = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable audio tools";
      };
    };

    image = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable image tools";
      };
    };

    video = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable video tools";
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs;
      mkIf cfg.enable [
        (mkIf cfg.audio.enable audacity)
        (
          mkIf cfg.image.enable
          krita
        )
        (
          mkIf cfg.image.enable
          gimp-with-plugins
        )
        (
          mkIf cfg.audio.enable
          davinci-resolve
        )
      ];
  };
}
