{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption mkOption;
  inherit (lib.${namespace}.types) monitors;
  inherit (builtins) toString;

  cfg = config.${namespace}.hardware.video;
in {
  options.${namespace}.hardware.video = {
    displayBackend = mkOption {
      type = types.enum ["x11" "wayland" "terminal"];
      default = null;
      description = ''
        The display backend to use. Choose between "x11", "wayland", or "none".
        If set to "none", no display server will be started.
      '';
    };
    disableWaylandOzone = mkEnableOption "Disable Wayland Ozone support";
    monitors = mkOption {
      type = monitors;
      default = {};
      description = ''
        A list of monitors to configure. Each monitor is a set of attributes
        that specify the monitor's properties.'';
    };
  };

  config = {
    # Configures the bootloader to use the monitors specified in the config.
    boot.kernelParams = mkIf (cfg.monitors != {}) (lib.mapAttrsToList (connector: m: "video=${connector}:${toString m.width}x${toString m.height}@${toString m.refreshRate}") cfg.monitors);

    environment.sessionVariables = mkIf (!cfg.disableWaylandOzone && cfg.displayBackend == "wayland") {
      NIXOS_OZONE_WL = "1";
    };

    assertions = [
      {
        assertion = cfg.displayBackend != null;
        message = ''
          Display backend must be set.
        '';
      }
    ];
  };
}
