{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.smartd;
in {
  options.${namespace}.services.smartd = {
    enable = mkEnableOption "Whether to enable smartd services";
  };

  config = mkIf cfg.enable {
    ${namespace}.services.msmtp.enable = true;

    sops.templates."msmtprc".restartUnits = ["smartd.service"];

    services.smartd = {
      enable = true;
      notifications.test = true;
      notifications.mail = {
        enable = true;
        sender = "bot@123mail.org";
        recipient = "bot@123mail.org";
      };
    };
  };
}
