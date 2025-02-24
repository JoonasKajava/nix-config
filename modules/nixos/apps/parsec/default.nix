{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.parsec;

  parsec-fix-desktop-item = pkgs.makeDesktopItem {
    name = "parsec-fix";
    exec = "rm /home/joonas/.parsec/window.json";
    desktopName = "Fix Parsec by deleting window.json";
  };
in {
  options.${namespace}.apps.parsec = {
    enable = mkEnableOption "Whether to install parsec";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      parsec-bin
      parsec-fix-desktop-item
    ];
  };
}
