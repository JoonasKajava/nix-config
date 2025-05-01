{lib, ...}:
with lib; {
  types = rec {
    monitors = types.attrsOf monitor;

    monitor = types.submodule {
      options = {
        width = mkOption {
          type = types.number;
          example = 1920;
          description = "Specifies the width of the monitor.";
        };

        height = mkOption {
          type = types.number;
          example = 1080;
          description = "Specifies the height of the monitor.";
        };

        refreshRate = mkOption {
          type = types.number;
          description = "Specifies the refresh rate of the monitor.";
          default = 60;
        };
        position = mkOption {
          type = types.str;
          description = "Specifies the position of the monitor relative to the first monitor. See hyprland docs.";
          default = "0x0";
        };
        scale = mkOption {
          type = types.number;
          description = "Specifies the scale of the monitor.";
          default = 1;
        };
      };
    };
  };
}
