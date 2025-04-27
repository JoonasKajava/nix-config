{lib, ...}:
with lib; {
  types = {
    monitor = types.submodule {
      options = {
        connector = mkOption {
          type = types.str;
          description = "Specifies what connector is used with the monitor.";
          example = "HDMI-A-2";
        };
        resolution = mkOption {
          type = types.str;
          example = "1920x1080";
          description = "Specifies the resolution of the monitor.";
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
