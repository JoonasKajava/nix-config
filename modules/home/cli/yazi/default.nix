{
  lib,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.yazi;
in {
  options.${namespace}.cli.yazi = {enable = mkEnableOption "yazi";};

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
        };
      };

      shellWrapperName = "y";
    };
  };
}
