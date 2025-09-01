{
  lib,
  config,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.obs-studio;
in {
  options.${namespace}.apps.obs-studio = {
    enable = lib.mkEnableOption "obs studio";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}
