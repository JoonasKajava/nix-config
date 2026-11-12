{den, ...}: {
  den.aspects.gaming.faugus = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        faugus-launcher
      ];
    };
  };
}
