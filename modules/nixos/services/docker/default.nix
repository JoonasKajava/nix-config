{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.docker;
in {
  options.${namespace}.services.docker = {
    enable = mkEnableOption "Whether to enable docker services";
    wallos = mkEnableOption "Whether to enable wallos container";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
      oci-containers.backend = "docker";
      oci-containers.containers = {
        wallos = mkIf cfg.wallos (import ./containers/wallos.nix {inherit config;});
      };
    };
  };
}
