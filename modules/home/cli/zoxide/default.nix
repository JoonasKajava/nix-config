{
  lib,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.zoxide;
in {
  options.${namespace}.cli.zoxide = {enable = mkEnableOption "zoxide";};

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
