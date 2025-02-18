{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.comma;
in {
  options.${namespace}.cli.comma = {enable = mkEnableOption "comma";};

  config = mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;

    myHome = {
      programs.nix-index.enable = true;
    };
  };
}
