{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.anki;
in {
  options.${namespace}.apps.anki = {
    enable = lib.mkEnableOption "anki";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      anki
    ];
  };
}
