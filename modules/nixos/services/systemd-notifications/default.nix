{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce mkOption types;

  cfg = config.${namespace}.services.systemd-notifications;

  checkConditions = pkgs.writeScript "checkConditions" ''
    #!/bin/sh
    STATUS=$(systemctl status --full "$1")

    case "$STATUS" in
      *"activating (auto-restart) (Result: timeout)"*) exit 1 ;;
      *) exit 0 ;;
    esac
    '';

  sendScript =
    pkgs.writeScriptBin "send-script.nu"
    # nu
    ''
#! /usr/bin/env nix-shell
#! nix-shell -i nu -p nushell
      def main [
        service: string,
      ] {
        try {
            let token = cat ${config.sops.secrets.ntfy-token.path}
            let message = (do -i { systemctl status --full $service | complete }).stdout
            http post --user "" --password $token --headers { Title: "Systemd service failed to run on ${config.networking.hostName}" Priority: "high" Tags: "" } $"https://ntfy.joonaskajava.com/nixos-system" $message
          } catch {|err| echo $err}
        }
    '';
in {
  options.${namespace}.services.systemd-notifications = {
    enable = mkEnableOption "Whether to enable systemd notifications";
    serviceName = lib.mkOption {
      type = lib.types.str;
      default = "notify@";
      description = "The name of the systemd service that will send notifications.";
    };
  };

  options.systemd.services = mkOption {
    type = with types;
      attrsOf (
        submodule {
          config.onFailure = lib.optionals cfg.enable ["${cfg.serviceName}%n.service"];
        }
      );
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [sendScript];
    systemd.services.${cfg.serviceName} = {
      description = "Systemd Notifications Service";
      onFailure = mkForce [];
      unitConfig = {
        StartLimitIntervalSec = "5m";
        StartLimitBurst = 1;
      };
      serviceConfig = {
        ExecCondition = "${checkConditions} %i";
        ExecStart = "${pkgs.nushell}/bin/nu ${lib.getExe sendScript} %i";
        Type = "oneshot";
      };
    };
  };
}
