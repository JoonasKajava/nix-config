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
    enableFishCompleter = mkEnableOption "fish completions";
  };

  config = mkIf (cfg.enable && cfg.enableFishCompleter) {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs = {
        fish = {
          enable = true;
          generateCompletions = true;
        };

        nushell = {
          extraConfig = let
            fish = lib.getExe config.programs.fish.package;
          in
            # nu
            ''
              let fish_completer = {|spans|
                ${fish} --command $"complete '--do-complete=($spans | str join ' ')'"
                | from tsv --flexible --noheaders --no-infer
                | rename value description
                | update value {
                    if ($in | path exists) {$'"($in | str replace "\"" "\\\"" )"'} else {$in}
                }
              }

              $env.config = {
                completions: {
                  external: {
                    enable: true
                    completer: $fish_completer
                  }
                }
              }
            '';
        };
      };
    };
  };
}
