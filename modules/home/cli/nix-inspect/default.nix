{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.nix-inspect;
in {
  options.${namespace}.cli.nix-inspect = {enable = mkEnableOption "nix-inspect";};

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nix-inspect
    ];
  };
}
