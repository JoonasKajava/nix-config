{
  lib,
  config,
  namespace,
  osConfig,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.suites.cli;
in {
  options.${namespace}.suites.cli = {
    enable =
      mkEnableOption "Whether to enable the CLI suite."
      // {
        default = osConfig.${namespace}.suites.cli.enable;
      };
  };

  config = mkIf cfg.enable {
    lumi.cli.fastfetch.enable = true;
  };
}
