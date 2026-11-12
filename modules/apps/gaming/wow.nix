{den, ...}: {
  # World of Warcraft
  den.aspects.gaming.wow = {
    includes = [den.aspects.gaming.faugus];
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        wowup-cf
      ];
    };
  };
}
