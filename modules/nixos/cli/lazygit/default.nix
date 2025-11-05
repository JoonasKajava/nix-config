{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.cli.lazygit;
in {
  options.${namespace}.cli.lazygit = {
    enable = mkEnableOption "Lazygit";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gh
      git
      difftastic
      commitizen
    ];

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
          };
          git = {
            pagers = [{externalDiffCommand = "difft --color=always";}];
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
