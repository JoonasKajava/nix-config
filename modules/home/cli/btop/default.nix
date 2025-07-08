{
  lib,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.btop;
in {
  options.${namespace}.cli.btop = {enable = mkEnableOption "btop";};

  config = mkIf cfg.enable {
    home.shellAliases = {
      htop = "btop";
      top = "btop";
    };
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
  };
}
