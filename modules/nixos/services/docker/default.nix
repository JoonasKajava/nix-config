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
  };

  config = mkIf cfg.enable {
    users.users.${config.${namespace}.user.name}.linger = true;

    environment.systemPackages = with pkgs; [
      lazydocker
    ];
    virtualisation = {
      oci-containers.backend = "docker";
      docker = {
        enable = true; # Disable the system wide Docker daemon
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
