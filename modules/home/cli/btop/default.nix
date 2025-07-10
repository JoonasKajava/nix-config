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
    };
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        cpu_single_graph = true;
      };
    };
  };
}
