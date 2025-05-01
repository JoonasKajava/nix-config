{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (lib.${namespace}.types) monitors;
  inherit (builtins) toString;

  cfg = config.${namespace}.hardware.video;
in {
  options.${namespace}.hardware.video = {
    enable = mkEnableOption "Video and screen functionality";
    terminalOnly = mkEnableOption "Whether system is does not support GUI.";
    monitors = mkOption {
      type = monitors;
      default = {};
      description = ''
        A list of monitors to configure. Each monitor is a set of attributes
        that specify the monitor's properties.'';
    };
  };

  config = mkIf cfg.enable {
    # Configures the bootloader to use the monitors specified in the config.
    boot.kernelParams = mkIf (cfg.monitors != {}) (lib.mapAttrsToList (connector: m: "video=${connector}:${toString m.width}x${toString m.height}@${toString m.refreshRate}") cfg.monitors);
  };
}
