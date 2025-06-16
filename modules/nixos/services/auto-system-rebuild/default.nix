{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.auto-system-rebuild;

  rebuildScript =
    pkgs.writeShellScriptBin "rebuild-script.nu"
    # nu
    ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i nu -p git nushell

      def notify [
        title: string
        message: string,
        priority: string,
        tags: list<string>
      ] {
          let token = (cat ${config.sops.secrets.ntfy-token.path});
          (http post
          --user=""
          --password=$"($token)"
          --headers {
            Title: $title
            Priority: $priority
            Tags: ($priority | str join ",")
          }
          $"ntfy.joonaskajava.com/nixos-system" $message)
      }

      cd /etc/nixos;

      let hostname = (sys host).hostname

      try {
        if (git status --porcelain | length) {
          notify "Automatic Rebuilding Aborted" "There are uncommitted changes in the NixOS configuration. Please commit or stash them before running the auto-rebuild script." "high" ["rotating_light"];
          exit;
        }

        git pull;

        nix-rebuild switch;

        notify "Automatic Rebuilding Succefull" $"($hostname) just performed automatic rebuild successfully." "default" ["white_check_mark"];
      } catch { |err|
        notify "Automatic Rebuilding Aborted" $"Unable to automatically rebuild the system due: ($err.msg)" "high" ["rotating_light"];
      };
    '';
in {
  options.${namespace}.services.auto-system-rebuild = {
    enable = mkEnableOption "Whether to enable automatic system rebuilding";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      rebuildScript
    ];
  };
}
