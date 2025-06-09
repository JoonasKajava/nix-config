{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.nushell;
in {
  options.${namespace}.cli.nushell = {
    enable = mkEnableOption "nushell";
    plugins = mkOption {
      default = with pkgs.nushellPlugins; [
        query
      ];
      description = "List of plugins to install.";
      example = lib.literalExpression "[ pkgs.nushell.net ]";
    };
    showFastfetchOnStartup = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to show fastfetch on Nushell startup.";
    };
  };

  imports = [
    ./fish_completer.nix
  ];

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.nushell;


    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      home.shell.enableNushellIntegration = true;
      programs = {
        carapace.enable = true;

        fish = {
          enable = true;
          generateCompletions = true;
        };

        nix-your-shell.enable = true;

        nushell = {
          enable = true;
          configFile.source = ./config.nu;
          environmentVariables = {
            CARAPACE_BRIDGES = "fish";
          };
          extraConfig =
            # nushell
            ''
              ${
                if cfg.showFastfetchOnStartup
                then lib.getExe pkgs.fastfetch
                else ""
              }
            ''
            + concatStringsSep "\n" (builtins.map (p: "plugin add ${getExe p}") cfg.plugins);
        };
      };
    };
  };
}
