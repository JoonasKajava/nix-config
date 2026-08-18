{
  den.aspects.libreoffice.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
