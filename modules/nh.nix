{den, ...}: {
  # Exposes flake apps under the name of each host / home for building with nh.
  perSystem = {pkgs, ...}: {
    packages = den.lib.nh.denPackages {fromFlake = true;} pkgs;
  };

  den.aspects.cli = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        nh
        dix # Required for diffs
      ];
    };
  };
}
