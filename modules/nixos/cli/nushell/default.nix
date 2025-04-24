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
        net
      ];
      description = "List of plugins to install.";
      example = lib.literalExpression "[ pkgs.nushell.net ]";
    };
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.nushell;

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.nushell = {
        enable = true;
        configFile.text = concatStringsSep "\n" [
          # nu
          ''
            let carapace_completer = {|spans|
              ${getExe pkgs.carapace} $spans.0 nushell ...$spans | from json
            }

            $env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append (source ${pkgs.nu_scripts}/share/nu_scripts/nu-hooks/nu-hooks/direnv/config.nu)
            )

          ''
          (builtins.readFile ./config.nu)
        ];
        extraConfig = concatStringsSep "\n" (builtins.map (p: "plugin add ${getExe p}") cfg.plugins);
      };
    };
  };
}
