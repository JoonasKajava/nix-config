{
  den.aspects.gimp.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      gimp3-with-plugins
    ];
  };
}
