{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.cli.git;
  user = config.${namespace}.user;
in {
  options.${namespace}.cli.git = {
    enable = mkEnableOption "Git";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.githubEmail "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    myHome = {
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        lfs.enable = true;
        extraConfig = {
          safe.directory = "/etc/nixos";
          push.autoSetupRemote = true;
        };
      };
    };
  };
}
