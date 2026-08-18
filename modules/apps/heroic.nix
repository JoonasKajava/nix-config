{
  den.aspects.gaming.heroic.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      heroic
    ];
  };
}
