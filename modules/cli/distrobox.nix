{
  den.aspects.distrobox = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.distrobox];
    };
  };
}
