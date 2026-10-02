{den, ...}: {
  den.aspects.podman = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        podman-compose
      ];
      virtualisation.podman = {
        enable = true;
        dockerCompat = true; # Creates a symlink from docker to podman
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
        autoPrune.enable = true;
      };
    };
  };

  den.aspects.podman-desktop = {
    includes = [
      den.aspects.podman
    ];
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        podman-desktop
      ];
    };
  };
}
