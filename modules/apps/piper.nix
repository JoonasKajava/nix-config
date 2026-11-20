{
  den.aspects.piper = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        piper
      ];
    };

    nixos = {lib, ...}: {
      services.ratbagd.enable = true;
    };
  };
}
