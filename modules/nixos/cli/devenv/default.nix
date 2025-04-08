{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli.devenv;
in {
  options.${namespace}.cli.devenv = {
    enable = mkEnableOption "devenv";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      devenv
    ];

    nix.settings = {
      trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
      substituters = ["https://devenv.cachix.org"];
      trusted-users = ["root" config.${namespace}.user.name];
    };
  };
}
