{den, ...}: {
  den.aspects.cli.nushell = {
    includes = with den.aspects; [
      starship
    ];
    nixos = {pkgs, ...}: {
      users.defaultUserShell = pkgs.nushell;
    };
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      home.shell.enableNushellIntegration = true;

      programs = {
        carapace = {
          enable = true;
          enableNushellIntegration = true;
        };

        fish = {
          enable = true;
          generateCompletions = true;
        };

        nix-your-shell.enable = true;

        nushell = let
          plugins = with pkgs.nushellPlugins; [query];
        in {
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
              {
                name = "open_editor";
                modifier = "none";
                keycode = "char_v";
                mode = "vi_normal";
                event = {send = "openeditor";};
              }
            ];
          };
          extraConfig =
            # nushell
            ''
              ${lib.getExe pkgs.fastfetch}

            ''
            + lib.concatStringsSep "\n" (map (p: "plugin add ${lib.getExe p}") plugins);
        };
      };
    };
  };
}
