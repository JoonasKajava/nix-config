{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.yazi;
in {
  options.mystuff.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };
  };
}
