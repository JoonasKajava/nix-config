{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (lib.${namespace}.types) monitor;

  cfg = config.${namespace}.hardware.video;
in {
  options.${namespace}.hardware.video = {
    enable = mkEnableOption "Video and screen functionality";
    terminalOnly = mkEnableOption "Whether system is does not support GUI.";
    monitors = mkOption {
      type = types.listOf monitor;
      default = [];
      description = ''
        A list of monitor configuration options.
        Each entry in the list is a submodule that
        configures a specific monitor.'';
    };
  };

  config = mkIf cfg.enable {
    # Configures the bootloader to use the monitors specified in the config.
    boot.kernelParams = mkIf (cfg.monitors != []) builtins.map (m: "video=${m.connector}:${m.resolution}@${m.refreshRate}") cfg.monitors;
  };
}
