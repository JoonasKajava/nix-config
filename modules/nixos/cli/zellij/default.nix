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
          theme = "tokyo-night-storm";
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
