{
  den.aspects.anyrun.homeManager = {pkgs, ...}: {
    programs.anyrun = {
      enable = true;
      config = {
        x.fraction = 0.5;
        y.fraction = 0.5;
        plugins = let
          mkPlugin = plugin: "${pkgs.anyrun}/lib/lib${plugin}.so";
        in [
          (mkPlugin "applications")
          (mkPlugin "symbols")
          (mkPlugin "websearch")
          (mkPlugin "translate")
        ];
      };
    };
  };
}
