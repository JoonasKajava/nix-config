{
  den.aspects.docker = {
    nixos = {pkgs, ...}: {
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
  };
}
