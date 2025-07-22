{
  lib,
  config,
  namespace,
  osConfig ? {},
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
    home.shellAliases = {
      cd-to-sops-secrets = "cd /etc/nixos/nix-config-private/modules/nixos/services/sops/secrets/";
    };
    lumi.cli = {
      fastfetch.enable = true;
      yazi.enable = true;
      btop.enable = true;
    };
  };
}
