{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.anyrun;
in {
  options.${namespace}.apps.anyrun = {
    enable = lib.mkEnableOption "anyrun";
  };

  config = lib.mkIf cfg.enable {
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
