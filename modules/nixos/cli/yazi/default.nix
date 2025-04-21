{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.yazi;
in {
  options.${namespace}.cli.yazi = {enable = mkEnableOption "yazi";};

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.yazi = {
        enable = true;
        settings = {
          manager = {
            show_hidden = true;
          };
        };

        shellWrapperName = "y";
      };
    };
  };
}
