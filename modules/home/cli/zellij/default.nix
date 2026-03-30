{
  lib,
  config,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli.zellij;
in {
  options.${namespace}.cli.zellij = {
    enable = mkEnableOption "Whether to install zellij";
    enableNushellIntegration =
      mkEnableOption "Whether to enable Nushell integration";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./tokyo-night-moon.kdl;
      settings = {
        theme = "tokyonight-moon";
        default_mode = "locked";
        show_startup_tips = false;
        # This doesn't work very well
        plugins.z-nav._props.location = "file:${inputs.vim-zellij-navigator}";

        keybinds = {
          shared_except = let
            mkZNav = bind: name: payload: {
              "bind \"${bind}\"" = {
                MessagePlugin = {
                  _args = ["z-nav"];
                  inherit name payload;
                  move_mod = "ctrl";
                };
              };
            };
          in
            {
              _args = ["locked"];
            }
            // (mkZNav "Ctrl h" "move_focus_or_tab" "left")
            // (mkZNav "Ctrl l" "move_focus_or_tab" "right")
            // (mkZNav "Ctrl j" "move_focus" "down")
            // (mkZNav "Ctrl k" "move_focus" "up");
        };

        # keybinds = {
        #   normal = let
        #     nums = builtins.genList (n: n + 1) 9 ++ [0];
        #   in
        #     builtins.listToAttrs (map (i: {
        #         name = ''bind "${toString i}"'';
        #         value = {
        #           GoToTab =
        #             if i == 0
        #             then 10
        #             else i;
        #           SwitchToMode = "Locked";
        #         };
        #       })
        #       nums)
        #     // builtins.listToAttrs (map (i: {
        #         name = ''bind "Ctrl ${toString i}"'';
        #         value = {
        #           GoToTab =
        #             if i == 0
        #             then 10
        #             else i;
        #         };
        #       })
        #       nums);
        #   locked = {
        #     "bind \"Ctrl h\"" = {MoveFocusOrTab = "Left";};
        #     "bind \"Ctrl j\"" = {MoveFocusOrTab = "Down";};
        #     "bind \"Ctrl k\"" = {MoveFocusOrTab = "Up";};
        #     "bind \"Ctrl l\"" = {MoveFocusOrTab = "Right";};
        #   };
        # };
      };
      # themes = {
      #   "tokyo-night-moon" = {
      #     themes = {
      #       "tokyo-night-moon" = {
      #         text_unselected = {
      #           base = "192 202 245";
      #           "background" = "34 36 54";
      #           "emphasis_0" = "255 158 100";
      #           "emphasis_1" = "42 195 222";
      #           "emphasis_2" = "158 206 106";
      #           "emphasis_3" = "187 154 247";
      #         };
      #         text_selected = {
      #           "base" = "192 202 245";
      #           "background" = "34 36 54";
      #           "emphasis_0" = "255 158 100";
      #           "emphasis_1" = "42 195 222";
      #           "emphasis_2" = "158 206 106";
      #           "emphasis_3" = "187 154 247";
      #         };
      #         ribbon_selected = {
      #           "base" = "56 62 90";
      #           "background" = "158 206 106";
      #           "emphasis_0" = "249 51 87";
      #           "emphasis_1" = "255 158 100";
      #           "emphasis_2" = "187 154 247";
      #           "emphasis_3" = "122 162 247";
      #         };
      #         ribbon_unselected = {
      #           "base" = "56 62 90";
      #           "background" = "169 177 214";
      #           "emphasis_0" = "249 51 87";
      #           "emphasis_1" = "192 202 245";
      #           "emphasis_2" = "122 162 247";
      #           "emphasis_3" = "187 154 247";
      #         };
      #         table_title = {
      #           "base" = "158 206 106";
      #           "background" = "0";
      #           "emphasis_0" = "255 158 100";
      #           "emphasis_1" = "42 195 222";
      #           "emphasis_2" = "158 206 106";
      #           "emphasis_3" = "187 154 247";
      #         };
      #         table_cell_selected = {
      #           "base" = "192 202 245";
      #           "background" = "56 62 90";
      #           "emphasis_0" = "255 158 100";
      #           "emphasis_1" = "42 195 222";
      #           "emphasis_2" = "158 206 106";
      #           "emphasis_3" = "187 154 247";
      #         };
      #         table_cell_unselected = {
      #           base = "192 202 245";
      #           background = "56 62 90";
      #           emphasis_0 = "255 158 100";
      #           emphasis_1 = "42 195 222";
      #           emphasis_2 = "158 206 106";
      #           emphasis_3 = "187 154 247";
      #         };
      #         list_selected = {
      #           base = "192 202 245";
      #           background = "56 62 90";
      #           emphasis_0 = "255 158 100";
      #           emphasis_1 = "42 195 222";
      #           emphasis_2 = "158 206 106";
      #           emphasis_3 = "187 154 247";
      #         };
      #         list_unselected = {
      #           base = "192 202 245";
      #           background = "56 62 90";
      #           emphasis_0 = "255 158 100";
      #           emphasis_1 = "42 195 222";
      #           emphasis_2 = "158 206 106";
      #           emphasis_3 = "187 154 247";
      #         };
      #         frame_selected = {
      #           base = "158 206 106";
      #           background = "0";
      #           emphasis_0 = "255 158 100";
      #           emphasis_1 = "42 195 222";
      #           emphasis_2 = "187 154 247";
      #           emphasis_3 = "0";
      #         };
      #         frame_highlight = {
      #           base = "255 158 100";
      #           background = "0";
      #           emphasis_0 = "187 154 247";
      #           emphasis_1 = "255 158 100";
      #           emphasis_2 = "255 158 100";
      #           emphasis_3 = "255 158 100";
      #         };
      #         exit_code_success = {
      #           base = "158 206 106";
      #           background = "0";
      #           emphasis_0 = "42 195 222";
      #           emphasis_1 = "56 62 90";
      #           emphasis_2 = "187 154 247";
      #           emphasis_3 = "122 162 247";
      #         };
      #         exit_code_error = {
      #           base = "249 51 87";
      #           background = "0";
      #           emphasis_0 = "224 175 104";
      #           emphasis_1 = "0";
      #           emphasis_2 = "0";
      #           emphasis_3 = "0";
      #         };
      #         multiplayer_user_colors = {
      #           player_1 = "187 154 247";
      #           player_2 = "122 162 247";
      #           player_3 = "0";
      #           player_4 = "224 175 104";
      #           player_5 = "42 195 222";
      #           player_6 = "0";
      #           player_7 = "249 51 87";
      #           player_8 = "0";
      #           player_9 = "0";
      #           player_10 = "0";
      #         };
      #         # themes = {
      #         #   "tokyo-night-moon" = {
      #         #     fg = "#c8d3f5";
      #         #     bg = "#2f334d";
      #         #     # Black should match the terminal background color
      #         #     # This ensures the top and bottom bars are transparent
      #         #     black = "#222436";
      #         #     red = "#ff757f";
      #         #     green = "#c3e88d";
      #         #     yellow = "#ffc777";
      #         #     blue = "#82aaff";
      #         #     magenta = "#c099ff";
      #         #     cyan = "#86e1fc";
      #         #     white = "#828bb8";
      #         #     orange = "#ff966c";
      #         #   };
      #         # };
      #       };
      #     };
      #   };
      # };
    };

    programs.nushell.extraConfig = mkIf cfg.enableNushellIntegration ''
      # zellij
      def start_zellij [] {
        if 'ZELLIJ' not-in ($env | columns) {
          if 'ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH == 'true' {
            zellij attach -c
          } else {
            zellij
          }

          if 'ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.ZELLIJ_AUTO_EXIT == 'true' {
            exit
          }
        }
      }

      start_zellij
    '';
  };
}
