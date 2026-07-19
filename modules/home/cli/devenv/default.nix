{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli.devenv;
in {
  options.${namespace}.cli.devenv = {
    enable = mkEnableOption "devenv";
  };

  config = mkIf cfg.enable {
    programs.devenv = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
