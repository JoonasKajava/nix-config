{den, ...}: {
  den.aspects.base = {
    includes = with den.aspects; [
      systemd-notifications
      cli
      cli.nushell

      den.batteries.hostname
      tailscale
    ];
  };
}
