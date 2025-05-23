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
  };

  imports = [
    ./fish_completer.nix
  ];

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.nushell;

    ${namespace}.cli.nushell.enableFishCompleter = false;

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      home.shell.enableNushellIntegration = true;

      programs.carapace.enable = true;
      programs.nix-your-shell.enable = true;

      programs.nushell = {
        enable = true;
        configFile.source = ./config.nu;
        extraConfig =
          # nushell
          ''
            ${lib.getExe pkgs.fastfetch} # display fastfetch on startup
          ''
          + concatStringsSep "\n" (builtins.map (p: "plugin add ${getExe p}") cfg.plugins);
      };
    };
  };
}
