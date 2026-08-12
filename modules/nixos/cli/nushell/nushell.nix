  {
    den.aspects.cli.nushell = {
      nixos = {pkgs, ...}: {
        users.defaultUserShell = pkgs.nushell;
      };
      homeManager = {pkgs, lib, config, ...}: {
        home.shell.enableNushellIntegration = true;

        programs = {
          carapace.enable = true;

          fish = {
            enable = true;
            generateCompletions = true;
          };

          nix-your-shell.enable = true;

          nushell = 
          let 
            plugins = [];
            in
            {
            enable = true;
            configFile.source = ./config.nu;
            environmentVariables = {
              CARAPACE_BRIDGES = "fish";
            };
            settings = {
              keybindings = [
                {
                  modifier = "control";
                  keycode = "char_l";
                  mode = ["emacs" "vi_normal" "vi_insert"];
                  event = null;
                }
              ];
            };
            extraConfig =
              # nushell
              ''
                ${ lib.getExe pkgs.fastfetch }

                let fish_completer = {|spans|
                  ${lib.getExe config.programs.fish.package} --command $"complete '--do-complete=($spans | str join ' ')'"
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
              ''
              + lib.concatStringsSep "\n" (map (p: "plugin add ${lib.getExe p}") plugins);
          };
        };
      };
    };
  }
