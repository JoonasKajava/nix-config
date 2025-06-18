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
    pkgs.writeScriptBin "rebuild-script.nu"
    # nu
    ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i nu -p git nushell

      def notify [
        title: string,
        message: string,
        priority: string,
        tags: string
      ] {
          let token = cat ${config.sops.secrets.ntfy-token.path}
          http post --user "" --password $token --headers { Title: $title Priority: $priority Tags: $tags } $"https://ntfy.joonaskajava.com/nixos-system" $message
      }

      cd /etc/nixos;

      let hostname = (sys host).hostname

      try {
        if ((git status --porcelain | length) > 0) {
          notify "Automatic Rebuilding Aborted" $"($hostname) has uncommitted changes in the NixOS configuration. Please commit or stash them before running the auto-rebuild script." "high" "rotating_light";
          exit;
        }

        git pull;

        nixos-rebuild switch;

        notify "Automatic Rebuilding Successful" $"($hostname) just performed automatic rebuild successfully." "default" "white_check_mark";
      } catch { |err|
        notify "Automatic Rebuilding Aborted" $"($hostname) had to abort rebuild due: ($err.rendered | ansi strip)" "high" "rotating_light";
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
    systemd = {
      timers.auto-system-rebuild = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
      services.auto-system-rebuild = {
        script = "${rebuildScript}/bin/rebuild-script.nu";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
