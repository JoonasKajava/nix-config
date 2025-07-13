{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.msmtp;
in {
  options.${namespace}.services.msmtp = {
    enable = mkEnableOption "Whether to enable msmtp services";
  };

  config = mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      setSendmail = true;
    };
    sops.templates."msmtprc".path = "/etc/msmtprc";
    sops.templates."msmtprc".content = ''
      defaults
      auth            on
      tls             on
      
      account         default
      host            ${config.sops.placeholder."smtp/host"}
      port            ${config.sops.placeholder."smtp/port-starttls"}
      tls_starttls    on
      user            ${config.sops.placeholder."smtp/username"}
      password        ${config.sops.placeholder."smtp/app-password"}
      from            ${config.sops.placeholder."smtp/from"}
    '';

    environment.etc."msmtprc".enable = false;
  };
}
