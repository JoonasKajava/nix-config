{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce mkOption types;

  cfg = config.${namespace}.services.systemd-notifications;

  sendScript =
    pkgs.writeScriptBin "send-script.nu"
    # nu
    ''
      def main [
        title: string,
        service: string,
      ] {
          let token = cat ${config.sops.secrets.ntfy-token.path}
          let message = (systemctl status --full $service)
          http post --user "" --password $token --headers { Title: $title Priority: "high" Tags: "" } $"https://ntfy.joonaskajava.com/nixos-system" $message
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
    systemd.services.${cfg.serviceName} = {
      description = "Systemd Notifications Service";
      onFailure = mkForce [];
      serviceConfig = {
        ExecStart = "${pkgs.nushell}/bin/nu ${lib.getExe sendScript} %i";
        Type = "oneshot";
      };
    };
  };
}
