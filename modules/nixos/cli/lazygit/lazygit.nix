{
  den.aspects.cli = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        gh
        git
        difftastic
        stable.commitizen
      ];

      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
          };
          git = {
            diffRenderers = [
              {
                command = "difft --color=always";
                type = "extDiff";
              }
            ];
            disableForcePushing = true;
          };
          customCommands = [
            {
              key = "c";
              command = "git cz c";
              description = "Commit with commitizen";
              context = "files";
              loadingText = "Opening commitizen commit tool";
              output = "terminal";
            }
          ];
        };
      };
    };
  };
}
