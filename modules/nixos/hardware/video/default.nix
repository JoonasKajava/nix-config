{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.hardware.video;
in {
  options.${namespace}.hardware.video = {
    enable = mkEnableOption "Video and screen functionality";
    terminalOnly = mkEnableOption "Whether system is does not support GUI.";
  };

  config =
    mkIf cfg.enable {
    };
}
