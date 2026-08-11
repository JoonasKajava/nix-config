{
  den.aspects.kdenlive.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      kdePackages.kdenlive
    ];
  };
}
