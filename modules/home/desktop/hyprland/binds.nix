{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf config.${namespace}.desktop.hyprland.enable {
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
    "$fileManager" = lib.getExe pkgs.nemo-with-extensions;
    "$browser" = lib.getExe pkgs.brave;
    "$menu" = "${lib.getExe pkgs.anyrun}";

    bind = [
      # Apps
      "$mainMod, RETURN, exec, $terminal"
      "ALT, SPACE, exec, $menu"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, B, exec, $browser"
      "$mainMod, D, exec, ${lib.getExe pkgs.discord}"
      "$mainMod, O, exec, ${lib.getExe pkgs.obsidian}"

      "$mainMod, Q, killactive,"
      "$mainMod SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill" # Quit active window and all open instances
      "$mainMod, F, fullscreen, 0"
      "$mainMod, M, fullscreen, 1"
      "$mainMod, T, togglefloating"

      # HJKL to change focus
      "$mainMod, H, movefocus, l"
      "$mainMod, J, movefocus, d"
      "$mainMod, K, movefocus, u"
      "$mainMod, L, movefocus, r"

      "$mainMod SHIFT, H, resizeactive, -100 0" # Reduce window width with keyboard
      "$mainMod SHIFT, J, resizeactive, 0 100" # Increase window height with keyboard
      "$mainMod SHIFT, K, resizeactive, 0 -100" # Reduce window height with keyboard
      "$mainMod SHIFT, L, resizeactive, 100 0" # Increase window width with keyboard

      "$mainMod ALT, H, movewindow, l" # Swap tiled window left
      "$mainMod ALT, J, movewindow, d" # Swap tiled window down
      "$mainMod ALT, K, movewindow, u" # Swap tiled window up
      "$mainMod ALT, L, movewindow, r" # Swap tiled window right

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
}
