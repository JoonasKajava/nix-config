{den, ...}: {
  den.aspects.smartd = {
    includes = [
      den.aspects.sops
      den.aspects.msmtp
    ];
    nixos = {
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
  };
}
