{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.cli.zellij;
in {
  options.${namespace}.cli.zellij = {
    enable = mkEnableOption "Whether to install zellij";
  };

  config = mkIf cfg.enable {
    myHome = {
      programs.zellij = {
        enable = true;
        settings = {
        };
      };
    };
  };
}
