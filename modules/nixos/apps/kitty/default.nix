{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.kitty;
in {
  options.${namespace}.apps.kitty = {
    enable = mkEnableOption "Whether to install kitty";
    disableOtherTerminals = mkEnableOption "Whether to disable other terminals";
  };

  config = mkIf cfg.enable {
    myHome = {
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
