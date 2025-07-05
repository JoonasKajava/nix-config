{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types mkOption;

  cfg = config.${namespace}.services.tailscale;
in {
  options.${namespace}.services.tailscale = {
    enable = mkEnableOption "Whether to enable tailscale services";
    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/tailscale_key";
      description = ''
        A file containing the auth key.
        Tailscale will be automatically started if provided.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };

    systemd.services.tailscaled-autoconnect = {
      after = ["sops-nix.service"];
    };
  };
}
