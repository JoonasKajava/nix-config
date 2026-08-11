{
  den.aspects.anki.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      anki
    ];
  };
}
