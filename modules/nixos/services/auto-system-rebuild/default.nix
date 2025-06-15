{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.auto-system-rebuild;

  rebuildScript =
    pkgs.writeShellScriptBin "rebuild-script.nu"
    # nu
    ''
      #! nix-shell -i nu -p nushell

      

      cd /etc/nixos;
      try {
        if (git status --porcelain | length) {
          echo "Changes detected, rebuilding system...";
          exit;
        } else {
          git pull;
        };

      } catch { |err|
        echo $err.msg
      };
    '';
in {
  options.${namespace}.services.auto-system-rebuild = {
    enable = mkEnableOption "Whether to enable automatic system rebuilding";
  };

  config =
    mkIf cfg.enable {
    assertions = [
      {
        assertion = config.${namespace}.services.ntfy.enable;
        message = ''
            Ntfy must be enabled and configured for auto-system-rebuild to work.
        '';
      }
    ];
    };
}
