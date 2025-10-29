{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli.zellij;
in {
  options.${namespace}.cli.zellij = {
    enable = mkEnableOption "Whether to install zellij";
    enableNushellIntegration =
      mkEnableOption "Whether to enable Nushell integration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.zellij = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          theme = "tokyo-night-moon";
          default_mode = "locked";
          show_startup_tips = false;
          keybinds = {
            normal = let
              nums = builtins.genList (n: n + 1) 9 ++ [0];
            in
              builtins.listToAttrs (map (i: {
                  name = ''bind "${toString i}"'';
                  value = {
                    GoToTab =
                      if i == 0
                      then 10
                      else i;
                    SwitchToMode = "Locked";
                  };
                })
                nums)
              // builtins.listToAttrs (map (i: {
                  name = ''bind "Ctrl ${toString i}"'';
                  value = {
                    GoToTab =
                      if i == 0
                      then 10
                      else i;
                  };
                })
                nums);
            locked = {
              "bind \"Ctrl h\"" = {MoveFocus = "Left";};
              "bind \"Ctrl j\"" = {MoveFocus = "Down";};
              "bind \"Ctrl k\"" = {MoveFocus = "Up";};
              "bind \"Ctrl l\"" = {MoveFocus = "Right";};
            };
          };
        };
        themes = {
          "tokyo-night-moon" = {
            themes = {
              "tokyo-night-moon" = {
                fg = "#c8d3f5";
                bg = "#2f334d";
                # Black should match the terminal background color
                # This ensures the top and bottom bars are transparent
                black = "#222436";
                red = "#ff757f";
                green = "#c3e88d";
                yellow = "#ffc777";
                blue = "#82aaff";
                magenta = "#c099ff";
                cyan = "#86e1fc";
                white = "#828bb8";
                orange = "#ff966c";
              };
            };
          };
        };
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
  };
}
