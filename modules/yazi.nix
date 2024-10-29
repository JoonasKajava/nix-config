{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.yazi;
in {
  options.mystuff.firefox = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };
  };
}
