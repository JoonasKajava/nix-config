{den, ...}: {
  den.aspects.msmtp = {
    nixos = {config, ...}: {
      includes = [
        den.aspects.sops
      ];

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
  };
}
