{den, ...}: {
  den.aspects.base = {
    includes = with den.aspects; [
      systemd-notifications
      backup
      cli
      cli.nushell

      tailscale
    ];
  };
}
