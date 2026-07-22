{
  lib,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.opencode;
in {
  options.${namespace}.cli.opencode = {enable = mkEnableOption "opencode";};

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
    };
  };
}
