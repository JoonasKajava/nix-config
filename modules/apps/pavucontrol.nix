{
  den.aspects.pavucontrol.homeManager = {pkgs, ...}: {
    home.packages = [
      pkgs.pavucontrol
    ];
  };
}
