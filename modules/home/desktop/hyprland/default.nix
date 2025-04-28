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
  inherit (lib.${namespace}) mkOpt;
  inherit (lib.${namespace}.types) monitor;

  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable =
      mkEnableOption "Whether to control hyprland with home manager"
      // {
        default = osConfig.${namespace}.desktop.hyprland.enable;
      };
    monitors = mkOption {
      type = types.listOf monitor;
      default = osConfig.${namespace}.hardware.video.monitors;
      description = ''
        A list of monitor configuration options.
        Each entry in the list is a submodule that
        configures a specific monitor.'';
    };
    autostart = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        A list of packages to autostart.
        Each entry in the list is a package that
        will be started when hyprland starts.'';
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Autostart programs
        exec-once = builtins.map (x: "${lib.getExe x}") (cfg.autostart
          ++ (with pkgs; [
            waybar
            hyprpaper
          ]));

        monitor =
          (builtins.map (x: "${x.connector}, ${x.resolution}@${toString x.refreshRate}, ${x.position}, ${toString x.scale}") cfg.monitors)
          ++ [", preferred, auto, 1"]; # Any new random monitor will be placed to the right of the last monitor.

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

          sensitivity = 1.0;
        };
        # Inspiration from https://github.com/mylinuxforwork/dotfiles/blob/main/share/dotfiles/.config/hypr/conf/keybindings/default.conf
        bindm = [
          "$mainMod, mouse:272, movewindow" # Move window with the mouse
          "$mainMod, mouse:273, resizewindow" # Resize window with the mouse
        ];

        binde = [
          "ALT,Tab,cyclenext" # Cycle between windows
          "ALT,Tab,bringactivetotop" # Bring active window to the top
        ];

        "$mainMod" = "SUPER";
        "$terminal" = lib.getExe pkgs.kitty;
        "$fileManager" = lib.getExe pkgs.kdePackages.dolphin;
        "$browser" = lib.getExe pkgs.brave;
        "$menu" = "${lib.getExe pkgs.wofi} --show drun";

        bind = [
          # Apps
          "$mainMod, T, exec, $terminal"
          "$mainMod, R, exec, $menu"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, B, exec, $browser"
          "$mainMod, D, exec, ${lib.getExe pkgs.discord}"
          "$mainMod, O, exec, ${lib.getExe pkgs.obsidian}"

          "$mainMod, Q, exec, killactive"
          "$mainMod SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill" # Quit active window and all open instances
          "$mainMod, F, fullscreen, 0"
          "$mainMod, M, fullscreen, 1"

          # HJKL to change focus
          "$mainMod, H, movefocus, l"
          "$mainMod, J, movefocus, d"
          "$mainMod, K, movefocus, u"
          "$mainMod, L, movefocus, r"

          "$mainMod SHIFT, H, resizeactive, -100 0" # Reduce window width with keyboard
          "$mainMod SHIFT, J, resizeactive, 0 100" # Increase window height with keyboard
          "$mainMod SHIFT, K, resizeactive, 0 -100" # Reduce window height with keyboard
          "$mainMod SHIFT, L, resizeactive, 100 0" # Increase window width with keyboard

          "$mainMod ALT, H, swapwindow, l" # Swap tiled window left
          "$mainMod ALT, J, swapwindow, d" # Swap tiled window down
          "$mainMod ALT, K, swapwindow, u" # Swap tiled window up
          "$mainMod ALT, L, swapwindow, r" # Swap tiled window right

          # Workspaces
          "$mainMod, 1, workspace, 1" # Open workspace 1
          "$mainMod, 2, workspace, 2" # Open workspace 2
          "$mainMod, 3, workspace, 3" # Open workspace 3
          "$mainMod, 4, workspace, 4" # Open workspace 4
          "$mainMod, 5, workspace, 5" # Open workspace 5
          "$mainMod, 6, workspace, 6" # Open workspace 6
          "$mainMod, 7, workspace, 7" # Open workspace 7
          "$mainMod, 8, workspace, 8" # Open workspace 8
          "$mainMod, 9, workspace, 9" # Open workspace 9
          "$mainMod, 0, workspace, 1" # Open workspace 10

          "$mainMod SHIFT, 1, movetoworkspace, 1" # Move active window to workspace 1
          "$mainMod SHIFT, 2, movetoworkspace, 2" # Move active window to workspace 2
          "$mainMod SHIFT, 3, movetoworkspace, 3" # Move active window to workspace 3
          "$mainMod SHIFT, 4, movetoworkspace, 4" # Move active window to workspace 4
          "$mainMod SHIFT, 5, movetoworkspace, 5" # Move active window to workspace 5
          "$mainMod SHIFT, 6, movetoworkspace, 6" # Move active window to workspace 6
          "$mainMod SHIFT, 7, movetoworkspace, 7" # Move active window to workspace 7
          "$mainMod SHIFT, 8, movetoworkspace, 8" # Move active window to workspace 8
          "$mainMod SHIFT, 9, movetoworkspace, 9" # Move active window to workspace 9
          "$mainMod SHIFT, 0, movetoworkspace, 1" # Move active window to workspace 10

          "$mainMod, Tab, workspace, m+1" # Open next workspace
          "$mainMod SHIFT, Tab, workspace, m-1" # Open previous workspace
        ];
      };
    };
  };
}
