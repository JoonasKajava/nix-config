{
  lib,
  config,
  namespace,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (builtins) toString;
  inherit (lib.${namespace}.types) monitors;

  cfg = config.${namespace}.desktop.hyprland;
  osCfg = osConfig.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable =
      mkEnableOption "Whether to control hyprland with home manager"
      // {
        default = osConfig.${namespace}.desktop.hyprland.enable;
      };
    monitors = mkOption {
      type = monitors;
      default = osConfig.${namespace}.hardware.video.monitors;
      description = ''
        A list of monitors to configure. Each monitor is a set of attributes
        that specify the monitor's properties. See the monitor type for more
        information on the available attributes.'';
    };
    autostart = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ''
        [
          (lib.getExe pkgs.waybar)
        ]
      '';
      description = ''
        A list of programs to start when Hyprland starts.
        Each entry in the list is a string that is passed
        to the exec-once setting in Hyprland's config.
        For example, you can use this to start waybar or
        other programs that you want to run when Hyprland
        starts.'';
    };
  };

  imports = [
    ./binds.nix
    ./hyprpanel.nix
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      # Systemd integration conflicts with uwsm.
      systemd.enable = !osConfig.programs.hyprland.withUWSM;

      settings = {
        # Autostart programs
        exec-once =
          cfg.autostart
          ++ osCfg.autostart
          ++ (with pkgs; [
            (lib.getExe waybar)
            (lib.getExe hyprpaper)
          ]);

        monitor =
          (lib.mapAttrsToList (connector: x: "${connector}, ${toString x.width}x${toString x.height}@${toString x.refreshRate}, ${x.position}, ${toString x.scale}") cfg.monitors)
          ++ [", preferred, auto, 1"]; # Any new random monitor will be placed to the right of the last monitor.

        xwayland.force_zero_scaling = true;

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
        };
        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 10;
          rounding_power = 2;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = true;

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0.15;
          accel_profile = "flat";
        };
      };
    };
  };
}
