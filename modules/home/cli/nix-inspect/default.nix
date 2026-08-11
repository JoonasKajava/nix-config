{
  den.aspects.cli.homeManager = {pkgs, ...}: {
    home.packages = [
      pkgs.nix-inspect
    ];
  };
}
