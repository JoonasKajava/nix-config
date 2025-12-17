{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.cli.git;
in {
  options.${namespace}.cli.git = {
    enable = mkEnableOption "Git";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.githubEmail "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.git = {
        enable = true;

        lfs.enable = true;
        settings = {
          user = {
            email = cfg.userEmail;
            name = cfg.userName;
          };

          init.defaultBranch = "main";

          safe.directory = "/etc/nixos";
          push.autoSetupRemote = true;
        };
      };
    };
  };
}
